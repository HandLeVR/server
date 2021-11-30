package de.handlevr.server.service.impl;

import de.handlevr.server.repository.UserRepository;
import de.handlevr.server.domain.User;
import de.handlevr.server.exception.UserAlreadyExistsException;
import de.handlevr.server.exception.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("userService")
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, BCryptPasswordEncoder bCryptPasswordEncoder) {
        this.userRepository = userRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
    }

    public User findUserById(long id) {
        Optional<User> user = userRepository.findById(id);
        if (!user.isPresent())
            throw new UserNotFoundException(id);
        return user.get();
    }

    public User saveUser(User user, boolean overwrite, boolean encryptPassword) {
        if (userRepository.findByUserName(user.getUserName()) != null && !overwrite)
            throw new UserAlreadyExistsException(user.getUserName());
        if (user.getId() != null && userRepository.findById(user.getId()).isPresent() && !overwrite)
            throw new UserAlreadyExistsException(user.getId());
        if (encryptPassword)
            user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        return userRepository.saveAndFlush(user);
    }
}
