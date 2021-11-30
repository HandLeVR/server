package de.handlevr.server.repository;

import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.TaskCollectionElement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TaskCollectionElementRepository extends JpaRepository<TaskCollectionElement, Long> {

    TaskCollectionElement findById(long id);

    TaskCollectionElement findFirstByTask(Task task);
}
