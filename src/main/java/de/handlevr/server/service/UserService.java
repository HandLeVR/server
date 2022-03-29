package de.handlevr.server.service;

import de.handlevr.server.domain.User;
import de.handlevr.server.repository.TaskAssignmentRepository;
import de.handlevr.server.repository.TaskCollectionAssignmentRepository;
import de.handlevr.server.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Transactional
@Service("userService")
public class UserService {

    private final UserRepository userRepository;
    private final TaskAssignmentRepository taskAssignmentRepository;
    private final TaskCollectionAssignmentRepository taskCollectionAssignmentRepository;

    @Autowired
    public UserService(UserRepository userRepository, TaskAssignmentRepository taskAssignmentRepository,
                       TaskCollectionAssignmentRepository taskCollectionAssignmentRepository) {
        this.userRepository = userRepository;
        this.taskAssignmentRepository = taskAssignmentRepository;
        this.taskCollectionAssignmentRepository = taskCollectionAssignmentRepository;
    }

    /*
     * Disables the user which means the full name and the username are made anonymous and the disabled field is set
     * to true. All task assignments and task results a removed too.
     *
     * Method needs to be placed in a class annotated with @Transactional. Otherwise, the removeAllByUser methods do
     * not work.
     *
     * Source: https://stackoverflow.com/questions/32269192/spring-no-entitymanager-with-actual-transaction-available-for-current-thread
     */
    public void disableUser(User user) {
        user.setDisabled(true);
        String newName = "Anonym";
        user.setFullName(newName);
        int i = 1;
        while (userRepository.findByUserName(newName + i).isPresent())
            i++;
        user.setUserName(newName + i);
        userRepository.save(user);
        taskAssignmentRepository.removeAllByUser(user);
        taskCollectionAssignmentRepository.removeAllByUser(user);
    }
}
