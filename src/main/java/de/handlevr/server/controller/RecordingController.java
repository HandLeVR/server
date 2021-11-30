package de.handlevr.server.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.domain.TaskResult;
import de.handlevr.server.repository.CoatRepository;
import de.handlevr.server.repository.RecordingRepository;
import de.handlevr.server.repository.TaskResultRepository;
import de.handlevr.server.service.FilesStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;

@RestController
public class RecordingController {

    @Autowired
    RecordingRepository recordingRepository;
    @Autowired
    CoatRepository coatRepository;
    @Autowired
    TaskResultRepository taskResultRepository;
    @Autowired
    FilesStorageService storageService;

    @GetMapping("/recordings")
    public List<Recording> getRecordings() {
        return recordingRepository.findAll();
    }

    @GetMapping("/recordings/noTaskResult")
    public Set<Recording> getRecordingsNoTaskResult() {
        return recordingRepository.findByTaskResultNull();
    }

    @GetMapping("/recordings/{id}")
    public Recording getRecording(@PathVariable Long id) {
        return recordingRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                String.format("Recording with the id %s not found", id)));
    }

    @GetMapping("/recordings/{id}/file")
    public ResponseEntity<Resource> getFile(@PathVariable Long id) {
        Resource file = storageService.load(getRecording(id).getZipPath());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
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
        recording.setTaskResult(null);
        recording = recordingRepository.save(recording);
        storageService.save(file, recording.getZipPath());
        unpackPreviewFile(recording);
        // add task result if it was sent with the recording
        if (taskResult != null) {
            taskResult.setId(null);
            taskResult.setRecording(recording);
            taskResultRepository.save(taskResult);
            recording.setTaskResult(taskResult);
            recording = recordingRepository.save(recording);
        }
        return recording;
    }

    @PutMapping(path = "/recordings")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Recording updateRecording(@RequestBody Recording recording) throws IOException {
        Recording oldRecording = getRecording(recording.getId());
        validateRecording(recording);
        if (!oldRecording.getData().equals(recording.getData()))
            storageService.rename(oldRecording.getZipPath(), recording.getZipPath());
        return recordingRepository.save(recording);
    }

    @DeleteMapping("/recordings/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteRecording(@PathVariable Long id) {
        Recording recording = getRecording(id);
        if (!recording.getUsedInTasks().isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASK");
        recordingRepository.deleteById(id);
    }

    private void validateRecording(Recording recording) {
        if (recordingRepository.existsByNameAndIdNot(recording.getName(), recording.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        if (recording.getCoat() != null && !coatRepository.existsById(recording.getCoat().getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "COAT");
        if (recording.getBaseCoat() != null && !coatRepository.existsById(recording.getBaseCoat().getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "COAT");
    }

    private void unpackPreviewFile(Recording recording) throws IOException {
        // Wrap the file system in a try-with-resources statement
        // to auto-close it when finished and prevent a memory leak
        try (FileSystem fileSystem = FileSystems.newFileSystem(recording.getZipPath())) {
            Path fileToExtract = fileSystem.getPath("preview.png");
            Files.copy(fileToExtract, recording.getPreviewPath());
        }
    }
}
