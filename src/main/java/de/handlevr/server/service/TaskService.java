package de.handlevr.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import de.handlevr.server.domain.Coat;
import de.handlevr.server.domain.Media;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.domain.Task;
import de.handlevr.server.repository.CoatRepository;
import de.handlevr.server.repository.MediaRepository;
import de.handlevr.server.repository.RecordingRepository;
import de.handlevr.server.repository.TaskRepository;
import de.handlevr.server.util.JsonUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Service
public class TaskService {

    final RecordingRepository recordingRepository;
    final TaskRepository taskRepository;
    final MediaRepository mediaRepository;
    final CoatRepository coatRepository;
    final PermissionService permissionService;
    final FilesStorageService storageService;
    final RecordingService recordingService;

    public TaskService(RecordingRepository recordingRepository, TaskRepository taskRepository,
                       MediaRepository mediaRepository, CoatRepository coatRepository,
                       PermissionService permissionService, FilesStorageService storageService,
                       RecordingService recordingService) {
        this.recordingRepository = recordingRepository;
        this.taskRepository = taskRepository;
        this.mediaRepository = mediaRepository;
        this.coatRepository = coatRepository;
        this.permissionService = permissionService;
        this.storageService = storageService;
        this.recordingService = recordingService;
    }


    /**
     * Imports an exported task from a zip file. We always create a new even if there is already a task with the same id
     * or name.
     */
    public List<Task> importTasks(String fileName, MultipartFile file) throws IOException {
        Path pathToZip = Media.root.resolve("Import").resolve(fileName);
        // remove .zip from filename
        fileName = FilenameUtils.removeExtension(fileName);
        Path extractFolder = Media.root.resolve("Import").resolve(fileName);
        try {
            return importTasksImpl(file, pathToZip, extractFolder);
        } finally {
            storageService.delete(extractFolder);
            storageService.delete(pathToZip);
        }
    }

    public List<Task> importTasksImpl(MultipartFile file, Path pathToZip, Path extractFolder) throws IOException {
        // save zip file on server
        storageService.save(file, pathToZip);

        // unzip files and get json file
        File jsonfile = storageService.unzip(pathToZip, extractFolder);

        if (!Files.exists(jsonfile.toPath()) || !JsonUtil.isJsonValid(Files.readString(jsonfile.toPath())))
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST);

        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(jsonfile);

        List<Task> taskList = new ArrayList<>();
        // read the JSON as list
        if (rootNode.isArray())
            taskList = new LinkedList<>(Arrays.asList(objectMapper.readValue(rootNode.toString(), Task[].class)));
            // read JSON as single Task object
        else if (rootNode.isObject())
            taskList.add(objectMapper.readValue(rootNode.toString(), Task.class));
        else
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST);

        // collect all used elements of all tasks to avoid importing an element twice
        List<Coat> usedCoats =
                taskList.stream().flatMap(t -> t.getUsedCoats().stream()).filter(distinctByKey(Coat::getId)).collect(Collectors.toList());
        List<Media> usedMedia =
                taskList.stream().flatMap(t -> t.getUsedMedia().stream()).filter(distinctByKey(Media::getId)).collect(Collectors.toList());
        List<Recording> usedRecordings =
                taskList.stream().flatMap(t -> t.getUsedRecordings().stream()).filter(distinctByKey(Recording::getId)).collect(Collectors.toList());

        for (Coat coat : usedCoats) {
            // only create a new coat if there isn't one with the same id and name
            if (coatRepository.existsByIdAndName(coat.getId(), coat.getName()))
                continue;

            // rename coat element if there is one with the same name
            int i = 1;
            String name = coat.getName();
            while (coatRepository.existsByName(coat.getName())) {
                coat.setName(name + " " + i);
                i++;
            }

            long oldId = coat.getId();
            coat.setId(null);
            coat.setPermission(permissionService.updatePermission(null));
            coat.setUsedInTasks(new ArrayList<>());
            coatRepository.save(coat);

            // replace the ids in the subtask json
            for (Task task : taskList)
                task.setSubTasks(replaceId(Arrays.asList("coatId", "baseCoatId"), oldId, coat.getId(),
                        task.getSubTasks()));
        }

        for (Media media : usedMedia) {
            // only create a new media element if there isn't one with the same id and name
            if (mediaRepository.existsByIdAndName(media.getId(), media.getName()))
                continue;

            // get file name before renaming the file
            String filename = media.getPath().getFileName().toString();

            // rename media element if there is one with the same name
            int i = 1;
            String name = media.getName();
            while (mediaRepository.existsByName(media.getName())) {
                media.setName(name + " " + i);
                i++;
            }
            media.updateData();

            long oldId = media.getId();
            media.setId(null);
            media.setPermission(permissionService.updatePermission(null));
            media.setUsedInTasks(new ArrayList<>());
            mediaRepository.save(media);

            // replace the ids in the subtask json
            for (Task task : taskList)
                task.setSubTasks(replaceId(Arrays.asList("audioId", "finalAudioId", "imageId", "videoId",
                        "reminderAudioId", "finalReminderAudioId"), oldId, media.getId(), task.getSubTasks()));

            // save the file
            File mediaFile = extractFolder.resolve("usedMedia").resolve(filename).toFile();
            FileUtils.copyFile(mediaFile, media.getPath().toFile());
        }

        for (Recording recording : usedRecordings) {
            // only create a new recording if there isn't one with the same id and name
            if (recordingRepository.existsByIdAndName(recording.getId(), recording.getName()))
                continue;

            // get file name before renaming the file
            String filename = recording.getZipPath().getFileName().toString();

            // rename recording if there is one with the same name
            int i = 1;
            String name = recording.getName();
            while (recordingRepository.existsByName(recording.getName())) {
                recording.setName(name + " " + i);
                i++;
            }

            long oldId = recording.getId();
            recording.setId(null);
            recording.setPermission(permissionService.updatePermission(null));
            List<Task> usedInTasks = new ArrayList<>();
            recording.setUsedInTasks(usedInTasks);
            recordingRepository.save(recording);

            // replace the ids in the subtask json
            for (Task task : taskList)
                task.setSubTasks(replaceId(List.of("recordingId"), oldId, recording.getId(), task.getSubTasks()));

            // save the file
            File recordingFile = extractFolder.resolve("usedRecordings").resolve(filename).toFile();
            FileUtils.copyFile(recordingFile, recording.getZipPath().toFile());
            recordingService.unpackPreviewFile(recording);
        }


        for (Task task : taskList) {
            // rename the task if there is one with the same name
            int i = 1;
            String name = task.getName();
            while (taskRepository.existsByName(task.getName())) {
                task.setName(name + " " + i);
                i++;
            }

            task.setPermission(permissionService.updatePermission(null));

            // generate new id
            task.setId(null);

            taskRepository.save(task);
        }

        return taskList;
    }

    /**
     * Is used detect elements already in a list when collecting them.
     */
    private <T> Predicate<T> distinctByKey(Function<? super T, Object> keyExtractor) {
        Map<Object, Boolean> map = new ConcurrentHashMap<>();
        return t -> map.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
    }

    /**
     * Tries to find the oldId in the subtask json replaces it with the newId.
     */
    private String replaceId(List<String> fieldNames, long oldId, long newId, String subTaskJson) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        ArrayNode arrayNode = mapper.createArrayNode();
        for (JsonNode jsonNode : mapper.readTree(subTaskJson)) {
            ObjectNode objectNode = (ObjectNode) jsonNode;
            replaceIdRecursively(mapper, fieldNames, oldId, newId, objectNode);
            arrayNode.add(objectNode);
        }
        return arrayNode.toString();
    }

    /**
     * Traverses through a json object. If a field is found wich name is contained in the fieldNames list and the value
     * is equals the oldId, it is replaced be the newId.
     */
    private void replaceIdRecursively(ObjectMapper mapper, List<String> fieldNames, long oldId, long newId,
                                      ObjectNode parent) throws JsonProcessingException {
        Iterator<Map.Entry<String, JsonNode>> fields = parent.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> jsonField = fields.next();
            String fieldName = jsonField.getKey();
            JsonNode node = jsonField.getValue();
            if (node.isValueNode()) {
                if (node.isTextual() && JsonUtil.isJsonValid(node.asText())) {
                    JsonNode subNode = mapper.readTree(node.asText());
                    if (subNode.isObject()) {
                        ObjectNode objectNode = (ObjectNode) subNode;
                        replaceIdRecursively(mapper, fieldNames, oldId, newId, objectNode);
                        parent.put(fieldName, objectNode.toString());
                    }
                } else if (fieldNames.contains(fieldName) && node.isNumber() && node.asLong() == oldId) {
                    parent.put(fieldName, newId);
                }
            } else if (node.isArray()) {
                ArrayNode arrayNode = parent.putArray(fieldName);
                for (JsonNode arrayItem : node) {
                    ObjectNode objectNode = (ObjectNode) arrayItem;
                    replaceIdRecursively(mapper, fieldNames, oldId, newId, objectNode);
                    arrayNode.add(objectNode);
                }
            } else if (node.isObject()) {
                ObjectNode objectNode = (ObjectNode) node;
                replaceIdRecursively(mapper, fieldNames, oldId, newId, objectNode);
                parent.replace(fieldName, objectNode);
            }
        }
    }
}