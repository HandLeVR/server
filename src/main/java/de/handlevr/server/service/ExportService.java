package de.handlevr.server.service;

import de.handlevr.server.domain.User;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface ExportService {

    Resource exportUser(long id);

    User importUser(MultipartFile file, boolean force);
}
