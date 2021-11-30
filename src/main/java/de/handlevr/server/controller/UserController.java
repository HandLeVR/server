package de.handlevr.server.controller;

import de.handlevr.server.domain.*;
import de.handlevr.server.repository.*;
import de.handlevr.server.service.impl.UserExportImportService;
import de.handlevr.server.service.impl.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/*
 * RESTful web services for all user related requests
 */
@RestController
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserGroupRepository userGroupRepository;
    @Autowired
    private TaskAssignmentRepository taskAssignmentRepository;
    @Autowired
    private TaskCollectionAssignmentRepository taskCollectionAssignmentRepository;
    @Autowired
    private TaskCollectionRepository taskCollectionRepository;
    @Autowired
    TaskResultRepository taskResultRepository;
    @Autowired
    private UserExportImportService userExportImportService;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/users")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<User> getUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/users/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId(authentication,#id)")
    public User getUser(@PathVariable Long id) {
        return userRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User with the id %s not found", id)));
    }

    @PostMapping("/users")
    @PreAuthorize("hasAuthority('Teacher')")
    public User createUser(@RequestBody User user) {
        validateUserName(user);
        user.setId(null);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    @PutMapping(path = "/users")
    @PreAuthorize("hasAuthority('Teacher') or @userSecurity.hasUserId(authentication,#id)")
    public @ResponseBody
    User updateUser(@RequestBody User user) {
        validateUserName(user);
        // we need to set the modifiable properties because if we just save the new user the password and assignments
        // are removed
        User currentUser = getUser(user.getId());
        currentUser.setRole(user.getRole());
        currentUser.setUserName(user.getUserName());
        currentUser.setFullName(user.getFullName());
        return userRepository.save(currentUser);
    }

    private void validateUserName(User user) {
        if (userRepository.existsByUserNameAndIdNot(user.getUserName(), user.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User with the name %s already " +
                    "exists", user.getUserName()));
        if (user.getUserName().contains(" "))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User name \" %s \" contains " +
                    "whitespaces", user.getUserName()));
    }

    @PutMapping(path = "/users/{id}/updatePassword")
    @PreAuthorize("@userSecurity.hasUserId(authentication,#id)")
    public @ResponseBody
    User updatePassword(@PathVariable Long id, @RequestBody String password) {
        User user = getUser(id);
        user.setPassword(passwordEncoder.encode(password));
        user.setPasswordChanged(true);
        return userRepository.save(user);
    }

    @DeleteMapping(value = "/users/{id}")
    @PreAuthorize("hasAuthority('Teacher') or @userSecurity.hasUserId(authentication,#id)")
    public void deleteUser(@PathVariable Long id) {
        // TODO abhängigkeiten
        userRepository.deleteById(id);
    }

    @GetMapping("/users/{id}/userGroups")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId(authentication,#id)")
    public Set<UserGroup> getUserGroups(@PathVariable Long id) {
        User user = getUser(id);
        return userGroupRepository.findByUsersContaining(user);
    }

    @GetMapping("/users/{id}/taskAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId(authentication,#id)")
    public Set<TaskAssignment> getTaskAssignments(@PathVariable Long id) {
        User user = getUser(id);
        return taskAssignmentRepository.findByUser(user);
    }

    @GetMapping("/users/{id}/taskAssignmentsWithTaskResults")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId(authentication,#id)")
    public Set<TaskAssignment> getTaskAssignmentsWithTaskResults(@PathVariable Long id) {
        User user = getUser(id);
        return taskAssignmentRepository.findByUserAndTaskResultsNotNull(user);
    }

    @PostMapping("/users/{id}/taskAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<TaskAssignment> addTaskAssignments(@PathVariable Long id,
                                                   @RequestBody List<TaskAssignment> taskAssignments) {
        User user = getUser(id);
        List<TaskAssignment> result = new ArrayList<>();
        for (TaskAssignment assignment : taskAssignments) {
            assignment.setId(null);
            assignment.setUser(user);
            result.add(taskAssignmentRepository.save(assignment));
        }
        return result;
    }

    @PostMapping("/users/{id}/taskCollectionAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<TaskCollectionAssignment> addTaskCollectionAssignments(@PathVariable Long id,
                                                                       @RequestBody List<TaskCollectionAssignment> assignments) {
        User user = getUser(id);
        List<TaskCollectionAssignment> result = new ArrayList<>();
        for (TaskCollectionAssignment assignment : assignments) {
            TaskCollection taskCollection =
                    taskCollectionRepository.findById(assignment.getTaskCollection().getId()).orElseThrow(() ->
                            new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task collection with the" +
                                    " id " +
                                    "%s not found", id)));
            assignment.setId(null);
            assignment.setUser(user);
            TaskCollectionAssignment updatedAssignment = taskCollectionAssignmentRepository.save(assignment);
            taskCollection.getTaskCollectionElements().forEach(taskCollectionElement ->
                    taskAssignmentRepository.save(new TaskAssignment(user, taskCollectionElement.getTask(),
                            updatedAssignment, null, updatedAssignment.getDeadline())));
            result.add(updatedAssignment);
        }
        return result;
    }

    @DeleteMapping(value = "/users/{userId}/taskAssignment/{taskAssignmentId}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteTaskAssignment(@PathVariable Long userId, @PathVariable Long taskAssignmentId) {
        TaskAssignment taskAssignment = taskAssignmentRepository.findById(taskAssignmentId).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task assignment with the id %s not " +
                        "found", taskAssignmentId)));
        if (!userId.equals(taskAssignment.getUser().getId()))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task assignment with the id %s is " +
                    "not assigned to the given user", taskAssignmentId));
        if (taskResultRepository.findFirstByTaskAssignmentId(taskAssignmentId) != null)
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("Task assignment with the id %s " +
                    "already has a task result", taskAssignmentId));
        taskAssignmentRepository.delete(taskAssignment);
    }

    @DeleteMapping(value = "/users/{userId}/taskCollectionAssignment/{taskCollectionAssignmentId}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteTaskCollectionAssignment(@PathVariable Long userId,
                                               @PathVariable Long taskCollectionAssignmentId) {
        TaskCollectionAssignment taskCollectionAssignment =
                taskCollectionAssignmentRepository.findById(taskCollectionAssignmentId).orElseThrow(() ->
                        new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task collection assignment " +
                                "with the id %s not found", taskCollectionAssignmentId)));
        if (!userId.equals(taskCollectionAssignment.getUser().getId()))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task collection assignment with " +
                    "the id %s is not assigned to the given user", taskCollectionAssignmentId));

        // create single task assignments by removing connections to task collection assignment if there are task
        // results - otherwise remove assignment
        for (TaskAssignment assignment : taskCollectionAssignment.getTaskAssignments())
            if (assignment.getTaskResults().isEmpty())
                taskAssignmentRepository.deleteById(assignment.getId());

        taskCollectionAssignmentRepository.deleteById(taskCollectionAssignmentId);
    }


    // TODO All following methods remain untouched might need updating

    @GetMapping("/users/{id}/export")
    @ResponseBody
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId(authentication,#id)")
    public ResponseEntity<Resource> exportUser(@PathVariable Long id) {
        Resource file = userExportImportService.exportUser(id);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"export_user_" + id + "\"").body(file);
    }

    @PostMapping("/users/import")
    @ResponseBody
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public ResponseEntity<User> importUser(@RequestParam("file") MultipartFile file, @RequestParam(value = "force",
            defaultValue = "false") boolean force) {
        User user = userExportImportService.importUser(file, force);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @PutMapping(value = "/users/{id}/logout")
    @PreAuthorize("@userSecurity.hasUserId(authentication,#id)")
    public ResponseEntity<User> logoutUser(@PathVariable Long id) {
        User user = getUser(id);
        //user.finishLastTrainingSession();
        userService.saveUser(user, true, false);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }
}
