package de.handlevr.server.repository;

import de.handlevr.server.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/*
 * Gives access to the user data table. A implementation of this class is generated automatically.
 */
@Repository
public interface UserRepository extends JpaRepository<User,Long> {

    User findByUserName(String userName);

    boolean existsByUserNameAndIdNot(String userName, Long id);

}
