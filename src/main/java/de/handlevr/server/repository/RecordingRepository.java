package de.handlevr.server.repository;

import de.handlevr.server.domain.Coat;
import de.handlevr.server.domain.Recording;
import de.handlevr.server.domain.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface RecordingRepository extends JpaRepository<Recording,Long> {

    boolean existsByCoat(Coat coat);

    boolean existsByBaseCoat(Coat baseCoat);

    boolean existsByNameAndIdNot(String name, Long id);

    Set<Recording> findByUsedInTasksContains(Task task);

    Set<Recording> findByTaskResultNull();
}
