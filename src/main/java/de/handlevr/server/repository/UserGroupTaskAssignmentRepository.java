package de.handlevr.server.repository;

import de.handlevr.server.domain.UserGroup;
import de.handlevr.server.domain.UserGroupTaskAssignment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface UserGroupTaskAssignmentRepository extends JpaRepository<UserGroupTaskAssignment, Long> {

    Set<UserGroupTaskAssignment> findByUserGroup(UserGroup userGroup);
}
