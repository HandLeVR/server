package de.handlevr.server.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import de.handlevr.server.domain.Media;
import de.handlevr.server.repository.MediaRepository;
import de.handlevr.server.repository.TaskRepository;
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
import java.util.List;

@RestController
public class MediaController {

    @Autowired
    MediaRepository mediaRepository;
    @Autowired
    TaskRepository taskRepository;
    @Autowired
    FilesStorageService storageService;

    @GetMapping("/media")
    public List<Media> getAllMedia() {
        return mediaRepository.findAll();
    }

    @GetMapping("/media/{id}")
    public Media getMedia(@PathVariable Long id) {
        return mediaRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                String.format("Media with the id %s not found", id)));
    }

    @GetMapping("/media/{id}/file")
    public ResponseEntity<Resource> file(@PathVariable Long id) {
        Resource file = storageService.load(getMedia(id).getPath());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
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
        if (mediaRepository.existsByNameAndIdNot(media.getName(), media.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        media.updateData();
        if (!oldMedia.getData().equals(media.getData()))
            storageService.rename(oldMedia.getPath(), media.getPath());
        return mediaRepository.save(media);
    }

    @PostMapping("/media")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Media createMedia(@RequestParam(name = "obj") String mediaJson,
                             @RequestParam(name = "file") MultipartFile file) throws IOException {
        Media newMedia = new ObjectMapper().readValue(mediaJson, Media.class);
        if (mediaRepository.existsByNameAndIdNot(newMedia.getName(), newMedia.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        newMedia.updateData();
        storageService.save(file, newMedia.getPath());
        newMedia.setId(null);
        return mediaRepository.save(newMedia);
    }
}
