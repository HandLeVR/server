package de.handlevr.server.service.impl;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import de.handlevr.server.domain.Media;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.repository.MediaRepository;
import de.handlevr.server.service.FilesStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.annotation.PostConstruct;

@Service
public class FilesStorageServiceImpl implements FilesStorageService {

    @Autowired
    MediaRepository mediaRepository;

    // Initializes the folders that we want to use to store our data.
    @PostConstruct
    public void init() {
        createDirectoryIfNeeded(Media.root);
        createDirectoryIfNeeded(Media.root.resolve(Media.images));
        createDirectoryIfNeeded(Media.root.resolve(Media.videos));
        createDirectoryIfNeeded(Media.root.resolve(Media.audio));
        createDirectoryIfNeeded(Media.root.resolve(Recording.recordings));
    }

    // Saves a file of a certain type in the appropriate folder
    @Override
    public void save(MultipartFile file, Path path) {
        try {
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) {
            throw new RuntimeException("Could not store the file. Error: " + e.getMessage());
        }
    }

    @Override
    public void rename(Path oldPath, Path newPath) throws IOException {
        Files.move(oldPath, newPath, StandardCopyOption.REPLACE_EXISTING);
    }

    private void createDirectoryIfNeeded(Path path) {
        try {
            if (!Files.exists(path))
                Files.createDirectory(path);
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize folder: " + path);
        }
    }

    // loads file of a certain type from the appropriate folder
    @Override
    public Resource load(Path path) {
        try {
            Resource resource = new UrlResource(path.toUri());

            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "File not found: " + resource.getFilename());
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Error: " + e.getMessage());
        }
    }

    @Override
    public void delete(Path path) {
        try {
            Files.delete(path);
        } catch (IOException e) {
            System.err.println("File not found " + path);
        }
    }
}
