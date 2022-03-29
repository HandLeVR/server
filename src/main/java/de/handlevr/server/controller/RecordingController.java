package de.handlevr.server.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.domain.TaskResult;
import de.handlevr.server.repository.CoatRepository;
import de.handlevr.server.repository.RecordingRepository;
import de.handlevr.server.repository.TaskRepository;
import de.handlevr.server.repository.TaskResultRepository;
import de.handlevr.server.service.FilesStorageService;
import de.handlevr.server.service.PermissionService;
import de.handlevr.server.service.RecordingService;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 * Handles all recording requests.
 */
@RestController
public class RecordingController {

    final RecordingRepository recordingRepository;
    final CoatRepository coatRepository;
    final TaskResultRepository taskResultRepository;
    final TaskRepository taskRepository;
    final PermissionService permissionService;
    final FilesStorageService storageService;
    final RecordingService recordingService;

    public RecordingController(RecordingRepository recordingRepository, CoatRepository coatRepository,
                               TaskResultRepository taskResultRepository, FilesStorageService storageService,
                               TaskRepository taskRepository, PermissionService permissionService,
                               RecordingService recordingService) {
        this.recordingRepository = recordingRepository;
        this.coatRepository = coatRepository;
        this.taskResultRepository = taskResultRepository;
        this.storageService = storageService;
        this.taskRepository = taskRepository;
        this.permissionService = permissionService;
        this.recordingService = recordingService;
    }

    @GetMapping("/recordings")
    public List<Recording> getRecordings() {
        return recordingRepository.findAll();
    }

    @GetMapping("/recordings/noTaskResult")
    public Set<Recording> getRecordingsNoTaskResult() {
        return recordingRepository.findByHasTaskResult(false);
    }

    @GetMapping("/recordings/{id}/file")
    public ResponseEntity<Resource> getFile(@PathVariable Long id) {
        Resource file = storageService.load(getRecording(id).getZipPath());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }

    @GetMapping("/recordings/{id}")
    public Recording getRecording(@PathVariable Long id) {
        return recordingRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                String.format("Recording with the id %s not found", id)));
    }

    @GetMapping("/recordings/{id}/file/preview")
    public ResponseEntity<Resource> getPreviewFile(@PathVariable Long id) {
        Resource file = storageService.load(getRecording(id).getPreviewPath());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }

    @PostMapping("/recordings")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or hasAuthority('Learner')")
    public Recording createRecording(@RequestParam(name = "obj") String recordingJson,
                                     @RequestParam(name = "file") MultipartFile file) throws IOException {
        Recording recording = new ObjectMapper().readValue(recordingJson, Recording.class);
        validateRecording(recording);
        recording.setId(null);
        TaskResult taskResult = recording.getTaskResult();
        // we create the task result manually, and it is transient anyway
        recording.setTaskResult(null);
        recording.setHasTaskResult(taskResult != null);
        // don't set the uploader of the recording as the creator or editor of the recording if it is a task result
        // we never use this information, and it prevents removing the user as the user object is used in a permission
        recording.setPermission(permissionService.updatePermission(null, taskResult != null));
        recording = recordingRepository.save(recording);
        storageService.save(file, recording.getZipPath());
        // the preview file has to be accessible individually
        recordingService.unpackPreviewFile(recording);
        // add task result if it was sent with the recording
        if (taskResult != null) {
            taskResult.setId(null);
            taskResult.setDate(new Date());
            taskResult.setRecording(recording);
            taskResultRepository.save(taskResult);
        }
        return recording;
    }

    /**
     * Checks whether a recording if the same name exists and whether the used coats exist.
     */
    private void validateRecording(Recording recording) {
        if (recordingRepository.existsByNameAndIdNot(recording.getName(), recording.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        if (recording.getCoat() != null && !coatRepository.existsById(recording.getCoat().getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "COAT");
        if (recording.getBaseCoat() != null && !coatRepository.existsById(recording.getBaseCoat().getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "COAT");
    }

    /**
     * Allows to rename the recording.
     */
    @PutMapping(path = "/recordings")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Recording updateRecording(@RequestBody Recording recording) throws IOException {
        Recording oldRecording = getRecording(recording.getId());
        validateRecording(recording);
        if (!oldRecording.getData().equals(recording.getData()))
            storageService.rename(oldRecording.getZipPath(), recording.getZipPath());
        recording.setPermission(permissionService.updatePermission(oldRecording.getPermission()));
        return recordingRepository.save(recording);
    }

    @DeleteMapping("/recordings/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteRecording(@PathVariable Long id) {
        Recording recording = getRecording(id);
        // recordings cannot be removed if used in a task
        if (!recording.getUsedInTasks().isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASK");
        recordingRepository.deleteById(id);
    }
}