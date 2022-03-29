package de.handlevr.server.repository;

import de.handlevr.server.domain.TaskCollection;
import de.handlevr.server.domain.TaskCollectionAssignment;
import de.handlevr.server.domain.User;
import de.handlevr.server.domain.UserGroupTaskAssignment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface TaskCollectionAssignmentRepository extends JpaRepository<TaskCollectionAssignment, Long> {

    Set<TaskCollectionAssignment> findByUserGroupTaskAssignment(UserGroupTaskAssignment userGroupTaskAssignment);

    Set<TaskCollectionAssignment> findByUserAndUserGroupTaskAssignment(User user, UserGroupTaskAssignment userGroupTaskAssignment);

    Set<TaskCollectionAssignment> findByTaskCollection(TaskCollection taskCollection);

    boolean existsByTaskCollection(TaskCollection taskCollection);

    void removeAllByUser(User user);
}
