package de.handlevr.server.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;

public interface FilesStorageService {
    void init();

    void save(MultipartFile file, Path path);

    Resource load(Path path);

    void delete(Path path);

    void rename(Path oldPath, Path newPath) throws IOException;

}
