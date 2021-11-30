package de.handlevr.server.repository;

import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.TaskAssignment;
import de.handlevr.server.domain.User;
import de.handlevr.server.domain.UserGroupTaskAssignment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface TaskAssignmentRepository extends JpaRepository<TaskAssignment, Long> {

    Set<TaskAssignment> findByUser(User user);

    Set<TaskAssignment> findByUserGroupTaskAssignment(UserGroupTaskAssignment userGroupTaskAssignment);

    Set<TaskAssignment> findByUserAndUserGroupTaskAssignment(User user, UserGroupTaskAssignment userGroupTaskAssignment);

    Set<TaskAssignment> findByUserAndTaskResultsNotNull(User user);

    TaskAssignment findFirstByTask(Task task);

}