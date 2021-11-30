package de.handlevr.server.repository;

import de.handlevr.server.domain.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepository extends JpaRepository<Task,Long> {

    boolean existsByNameAndIdNot(String name, Long id);
}
