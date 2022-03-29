package de.handlevr.server.repository;

import de.handlevr.server.domain.User;
import de.handlevr.server.domain.UserGroup;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface UserGroupRepository extends JpaRepository<UserGroup, Long> {

    Set<UserGroup> findByUsersContaining(User user);

    boolean existsByNameAndIdNot(String userName, Long id);
}