package de.handlevr.server.authentification;

import de.handlevr.server.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;

/**
 * Allows to use a custom Spring EL expression to test whether the token used in a request belongs to a specific user.
 *
 * Source: https://stackoverflow.com/questions/51712724/how-to-allow-a-user-only-access-their-own-data-in-spring-boot-spring-security
 */
public class UserSecurity {

    @Autowired
    private UserRepository userRepository;

    public boolean hasUserId(Authentication authentication, Long userId) {
        String username = authentication.getPrincipal().toString();
        if (userRepository.findByUserName(username).isEmpty())
            return false;
        return userId.equals(userRepository.findByUserName(username).get().getId());
    }
}