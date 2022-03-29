package de.handlevr.server.controller;

import de.handlevr.server.domain.Recording;
import de.handlevr.server.domain.TaskResult;
import de.handlevr.server.domain.User;
import de.handlevr.server.repository.TaskResultRepository;
import de.handlevr.server.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

/**
 * Handles all task result requests.
 */
@RestController
public class TaskResultController {

    final UserRepository userRepository;
    final TaskResultRepository taskResultRepository;

    public TaskResultController(UserRepository userRepository, TaskResultRepository taskResultRepository) {
        this.userRepository = userRepository;
        this.taskResultRepository = taskResultRepository;
    }

    @DeleteMapping("/taskResult/{id}/")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or hasAuthority('Learner')")
    public void deleteTaskResult(@PathVariable Long id) {
        TaskResult taskResult = taskResultRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                String.format("Task result with the id %s not found", id)));

        // if the user is no teacher he can only remove his own task results
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Optional<User> user = userRepository.findByUserName(authentication.getName());
        if (user.isEmpty() || (user.get().getRole().equals(User.Role.Learner) &&
                !taskResult.getTaskAssignment().getUser().getId().equals(user.get().getId())))
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);

        taskResultRepository.deleteById(id);
    }
}
