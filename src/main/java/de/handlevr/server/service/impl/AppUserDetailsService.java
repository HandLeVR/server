package de.handlevr.server.service.impl;

import de.handlevr.server.domain.User;
import de.handlevr.server.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Returns user details from the database.
 * Cannot be removed because otherwise we get a NestedServletException.
 */
@Component
public class AppUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
        User user = userRepository.findByUserName(s);

        if(user == null) {
            throw new UsernameNotFoundException(String.format("The username %s doesn't exist", s));
        }

        List<GrantedAuthority> authorities = new ArrayList<>();
        /*user.getRoles().forEach(role -> {
            authorities.add(new SimpleGrantedAuthority(role.getRoleName()));
        });*/

        User.Role role = user.getRole();
        authorities.add(new SimpleGrantedAuthority(role.name()));
        UserDetails userDetails = new org.springframework.security.core.userdetails.User(user.getUserName(), user.getPassword(), authorities);

        return userDetails;
    }
}
