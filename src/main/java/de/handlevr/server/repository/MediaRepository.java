package de.handlevr.server.repository;

import de.handlevr.server.domain.Media;
import de.handlevr.server.domain.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface MediaRepository extends JpaRepository<Media, Long> {

    boolean existsByNameAndIdNot(String name, Long id);

    Set<Media> findByUsedInTasksContains(Task task);

    boolean existsByIdAndName(long id, String name);

    boolean existsByName(String name);
}