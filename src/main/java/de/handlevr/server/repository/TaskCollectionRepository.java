package de.handlevr.server.repository;

import de.handlevr.server.domain.TaskCollection;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskCollectionRepository extends JpaRepository<TaskCollection, Long> {

    boolean existsByNameAndIdNot(String name, Long id);
}