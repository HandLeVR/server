package de.handlevr.server.repository;

import de.handlevr.server.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.Set;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    
    Set<User> findAllByDisabled(boolean disabled);

    Optional<User> findByUserName(String userName);

    boolean existsByUserNameAndIdNot(String userName, Long id);

}
