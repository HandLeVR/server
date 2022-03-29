package de.handlevr.server.repository;

import de.handlevr.server.domain.TaskResult;
import org.springframework.data.jpa.repository.JpaRepository;


public interface TaskResultRepository extends JpaRepository<TaskResult, Long> {

    TaskResult findById(long id);

    boolean existsByTaskAssignmentId(long id);

    boolean existsByTaskAssignment_TaskId(long id);
}