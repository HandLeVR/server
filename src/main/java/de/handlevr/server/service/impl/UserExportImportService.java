package de.handlevr.server.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import de.handlevr.server.exception.CryptoException;
import de.handlevr.server.domain.User;
import de.handlevr.server.exception.InternalServerErrorException;
import de.handlevr.server.exception.UserAlreadyExistsException;
import de.handlevr.server.repository.UserRepository;
import de.handlevr.server.service.ExportService;
import de.handlevr.server.util.CryptoUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/*
 * Enables the import and export of a user.
 */
@Service
public class UserExportImportService implements ExportService {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Override
    public Resource exportUser(long id) {
        try {
            User user = userService.findUserById(id);
            ObjectMapper mapper = new ObjectMapper();
            ObjectNode json = mapper.valueToTree(user);
            json.put("password",user.getPassword());
            return new ByteArrayResource(CryptoUtils.encrypt(json.toString().getBytes()));
        } catch (CryptoException e) {
            e.printStackTrace();
            throw new InternalServerErrorException();
        }
    }

    @Override
    public User importUser(MultipartFile file, boolean force) {
        try {
            byte[] decoded = CryptoUtils.decrypt(file.getBytes());
            ObjectMapper mapper = new ObjectMapper();
            User user = mapper.readValue(decoded, User.class);
            User existentUser = userRepository.findByUserName(user.getUserName());
            if (existentUser != null && !force)
                throw new UserAlreadyExistsException(user.getUserName());
            if (!force)
                user.setId(null);
            else if (existentUser != null)
                user.setId(existentUser.getId());
            return userService.saveUser(user,true,false);
        } catch (IOException | CryptoException e) {
            e.printStackTrace();
            throw new InternalServerErrorException();
        }
    }
}
