package de.handlevr.server.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import de.handlevr.server.domain.Media;
import de.handlevr.server.repository.MediaRepository;
import de.handlevr.server.repository.TaskRepository;
import de.handlevr.server.service.FilesStorageService;
import de.handlevr.server.service.PermissionService;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;

/**
 * Endpoint for all media requests.
 */
@RestController
public class MediaController {

    final MediaRepository mediaRepository;
    final TaskRepository taskRepository;
    final FilesStorageService storageService;
    final PermissionService permissionService;

    public MediaController(MediaRepository mediaRepository, TaskRepository taskRepository,
                           FilesStorageService storageService, PermissionService permissionService) {
        this.mediaRepository = mediaRepository;
        this.taskRepository = taskRepository;
        this.storageService = storageService;
        this.permissionService = permissionService;
    }

    @GetMapping("/media")
    public List<Media> getAllMedia() {
        return mediaRepository.findAll();
    }

    /**
     * Returns the corresponding file of a media entry.
     */
    @GetMapping("/media/{id}/file")
    public ResponseEntity<Resource> file(@PathVariable Long id) {
        Resource file = storageService.load(getMedia(id).getPath());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }

    @GetMapping("/media/{id}")
    public Media getMedia(@PathVariable Long id) {
        return mediaRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                String.format("Media with the id %s not found", id)));
    }

    @DeleteMapping("/media/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteMedia(@PathVariable Long id) {
        Media media = getMedia(id);
        if (!media.getUsedInTasks().isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        mediaRepository.deleteById(id);
        storageService.delete(media.getPath());
    }

    @PutMapping(path = "/media")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Media updateMedia(@RequestBody Media media) throws IOException {
        Media oldMedia = getMedia(media.getId());

        // cannot update if a media element with the same name already exists
        if (mediaRepository.existsByNameAndIdNot(media.getName(), media.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT);

        // update the name of the path and the name of the file
        media.updateData();
        if (!oldMedia.getData().equals(media.getData()))
            storageService.rename(oldMedia.getPath(), media.getPath());

        media.setPermission(permissionService.updatePermission(oldMedia.getPermission()));
        return mediaRepository.save(media);
    }

    @PostMapping("/media")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Media createMedia(@RequestParam(name = "obj") String mediaJson,
                             @RequestParam(name = "file") MultipartFile file) throws IOException {
        Media newMedia = new ObjectMapper().readValue(mediaJson, Media.class);
        // cannot create media if a media element with the same name already exists
        if (mediaRepository.existsByName(newMedia.getName()))
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        newMedia.updateData();
        storageService.save(file, newMedia.getPath());
        newMedia.setId(null);
        newMedia.setPermission(permissionService.updatePermission(null));
        return mediaRepository.save(newMedia);
    }
}