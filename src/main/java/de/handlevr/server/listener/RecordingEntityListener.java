package de.handlevr.server.listener;

import de.handlevr.server.domain.Recording;
import de.handlevr.server.service.FilesStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import javax.persistence.PostRemove;

/**
 * This listener ensures that the files belonging to a recording are removed if the recording is removed.
 */
@Component
public class RecordingEntityListener {

    private static FilesStorageService storageService;

    @Autowired
    public void setFileStorageService(FilesStorageService filesStorageService) {
        storageService = filesStorageService;
    }

    @PostRemove
    private void afterRemove(Recording recording) {
        storageService.delete(recording.getZipPath());
        storageService.delete(recording.getPreviewPath());
    }

}
