package de.handlevr.server.repository;

import de.handlevr.server.domain.Permission;
import de.handlevr.server.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PermissionRepository extends JpaRepository<Permission,Long> {

    boolean existsByCreatedBy(User user);

    boolean existsByLastEditedBy(User user);
}
