package de.handlevr.server.repository;

import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.TaskCollectionElement;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskCollectionElementRepository extends JpaRepository<TaskCollectionElement, Long> {

    TaskCollectionElement findById(long id);

    boolean existsByTask(Task task);
}
