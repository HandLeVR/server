package de.handlevr.server.repository;

import de.handlevr.server.domain.Coat;
import de.handlevr.server.domain.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface CoatRepository extends JpaRepository<Coat, Long> {

    Set<Coat> findByUsedInTasksContains(Task task);
}