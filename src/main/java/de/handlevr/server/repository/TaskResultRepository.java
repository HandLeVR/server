package de.handlevr.server.repository;

import de.handlevr.server.domain.TaskResult;
import org.springframework.data.jpa.repository.JpaRepository;


public interface TaskResultRepository extends JpaRepository<TaskResult, Long> {

    TaskResult findById(long id);

    TaskResult findFirstByTaskAssignmentId(long id);

    TaskResult findFirstByTaskAssignment_TaskId(long id);
}