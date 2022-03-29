package de.handlevr.server.repository;

import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    boolean existsByNameAndIdNot(String name, Long id);
    
    boolean existsByName(String name);

    Set<Task> findAllByPermission_CreatedBy(User user);
}