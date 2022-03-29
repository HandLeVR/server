package de.handlevr.server.service;

import de.handlevr.server.domain.Recording;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;

@Service
public class RecordingService {

    /**
     * Unpacks the preview file, so it is possible to download it separately.
     */
    public void unpackPreviewFile(Recording recording) throws IOException {
        // Wrap the file system in a try-with-resources statement
        // to auto-close it when finished and prevent a memory leak
        try (FileSystem fileSystem = FileSystems.newFileSystem(recording.getZipPath())) {
            Path fileToExtract = fileSystem.getPath("preview.png");
            Files.copy(fileToExtract, recording.getPreviewPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}