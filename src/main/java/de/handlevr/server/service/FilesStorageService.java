package de.handlevr.server.service;

import de.handlevr.server.domain.Media;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.repository.MediaRepository;
import org.apache.commons.io.FileUtils;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * Provides methods to handle files.
 */
@Service
public class FilesStorageService {

    final
    MediaRepository mediaRepository;

    public final static Path importFolder = Paths.get("Import");

    public FilesStorageService(MediaRepository mediaRepository) {
        this.mediaRepository = mediaRepository;
    }

    /**
     * Initializes the folders that we want to use to store our data.
     */
    @PostConstruct
    public void init() {
        createDirectoryIfNeeded(Media.root);
        createDirectoryIfNeeded(Media.root.resolve(Media.images));
        createDirectoryIfNeeded(Media.root.resolve(Media.videos));
        createDirectoryIfNeeded(Media.root.resolve(Media.audio));
        createDirectoryIfNeeded(Recording.rootPath.resolve(Recording.recordingsPath));
        createDirectoryIfNeeded(Recording.rootPath.resolve(Recording.taskResultsPath));
        createDirectoryIfNeeded(Media.root.resolve(importFolder));
    }

    private void createDirectoryIfNeeded(Path path) {
        try {
            if (!Files.exists(path))
                Files.createDirectory(path);
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize folder: " + path);
        }
    }

    /**
     * Saves a file of a certain type in the appropriate folder.
     */
    public void save(MultipartFile file, Path path) {
        try {
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) {
            throw new RuntimeException("Could not store the file. Error: " + e.getMessage());
        }
    }

    public void rename(Path oldPath, Path newPath) throws IOException {
        Files.move(oldPath, newPath, StandardCopyOption.REPLACE_EXISTING);
    }

    /**
     * Loads the file of a certain type from the appropriate folder.
     */
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

    public void delete(Path path) {
        try {
            File file = new File(String.valueOf(path));
            if(file.isDirectory()){
                FileUtils.deleteDirectory(file);
            }
            else {
                Files.delete(path);
            }
        } catch (IOException e) {
            System.err.println("File not found " + path);
        }
    }

    public File unzip(Path source, Path target) throws IOException{
        String filename = source.toFile().getName();
        filename = filename.substring(0,filename.lastIndexOf('.'));

        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(source.toFile()))) {

            // list files in zip
            ZipEntry zipEntry = zis.getNextEntry();

            while (zipEntry != null) {

                boolean isDirectory = false;
                // example 1.1
                // some zip stored files and folders separately
                // e.g data/
                //     data/folder/
                //     data/folder/file.txt
                if (zipEntry.getName().endsWith(File.separator)) {
                    isDirectory = true;
                }

                Path newPath = zipSlipProtect(zipEntry, target);

                if (isDirectory) {
                    Files.createDirectories(newPath);
                } else {

                    // example 1.2
                    // some zip stored file path only, need create parent directories
                    // e.g data/folder/file.txt
                    if (newPath.getParent() != null) {
                        if (Files.notExists(newPath.getParent())) {
                            Files.createDirectories(newPath.getParent());
                        }
                    }

                    // copy files, nio
                    Files.copy(zis, newPath, StandardCopyOption.REPLACE_EXISTING);

                    // copy files, classic
                    /*try (FileOutputStream fos = new FileOutputStream(newPath.toFile())) {
                        byte[] buffer = new byte[1024];
                        int len;
                        while ((len = zis.read(buffer)) > 0) {
                            fos.write(buffer, 0, len);
                        }
                    }*/
                }

                zipEntry = zis.getNextEntry();

            }
            zis.closeEntry();
        }

        return target.resolve(filename+".json").toFile();
    }

    // protect zip slip attack
    public static Path zipSlipProtect(ZipEntry zipEntry, Path targetDir)
            throws IOException {

        // test zip slip vulnerability
        // Path targetDirResolved = targetDir.resolve("../../" + zipEntry.getName());

        Path targetDirResolved = targetDir.resolve(zipEntry.getName());

        // make sure normalized file still has targetDir as its prefix
        // else throws exception
        Path normalizePath = targetDirResolved.normalize();
        if (!normalizePath.startsWith(targetDir)) {
            throw new IOException("Bad zip entry: " + zipEntry.getName());
        }

        return normalizePath;
    }
}
