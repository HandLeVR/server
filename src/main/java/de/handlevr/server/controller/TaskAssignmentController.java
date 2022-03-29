package de.handlevr.server.controller;

import de.handlevr.server.domain.TaskAssignment;
import de.handlevr.server.domain.TaskResult;
import de.handlevr.server.domain.User;
import de.handlevr.server.repository.TaskAssignmentRepository;
import de.handlevr.server.repository.TaskResultRepository;
import de.handlevr.server.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.Date;
import java.util.Optional;

/**
 * Handles task assignment requests.
 */
@RestController
public class TaskAssignmentController {

    final TaskAssignmentRepository taskAssignmentRepository;
    final TaskResultRepository taskResultRepository;
    final UserRepository userRepository;

    public TaskAssignmentController(TaskAssignmentRepository taskAssignmentRepository,
                                    TaskResultRepository taskResultRepository, UserRepository userRepository) {
        this.taskAssignmentRepository = taskAssignmentRepository;
        this.taskResultRepository = taskResultRepository;
        this.userRepository = userRepository;
    }

    /**
     * Allows finishing tasks which do not contain a painting task.
     */
    @PutMapping(path = "/taskAssignments/{id}/finishTask")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or hasAuthority('Learner')")
    public TaskResult finishTask(@PathVariable Long id) {
        TaskAssignment taskAssignment =
                taskAssignmentRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        // check if task assignment is assigned to the user sending the finish task request
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Optional<User> user = userRepository.findByUserName(authentication.getName());
        if (user.isEmpty() || !taskAssignment.getUser().getId().equals(user.get().getId()))
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);

        // create task result without recording
        TaskResult taskResult = new TaskResult();
        taskResult.setDate(new Date());
        taskResult.setTaskAssignment(taskAssignment);

        return taskResultRepository.save(taskResult);
    }
}
