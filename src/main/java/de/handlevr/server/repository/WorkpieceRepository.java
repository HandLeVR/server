package de.handlevr.server.repository;

import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.Workpiece;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface WorkpieceRepository extends JpaRepository<Workpiece,Long> {

    Set<Workpiece> findByUsedInTasksContains(Task task);
}
