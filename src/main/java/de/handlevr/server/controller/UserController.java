package de.handlevr.server.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import de.handlevr.server.domain.*;
import de.handlevr.server.repository.*;
import de.handlevr.server.service.PermissionService;
import de.handlevr.server.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Handles request dealing with the users.
 */
@RestController
public class UserController {

    final TaskResultRepository taskResultRepository;
    final TaskRepository taskRepository;
    final PermissionService permissionService;
    private final UserService userService;
    private final UserRepository userRepository;
    private final UserGroupRepository userGroupRepository;
    private final TaskAssignmentRepository taskAssignmentRepository;
    private final TaskCollectionAssignmentRepository taskCollectionAssignmentRepository;
    private final TaskCollectionRepository taskCollectionRepository;
    private final PasswordEncoder passwordEncoder;

    public UserController(UserService userService, UserRepository userRepository,
                          UserGroupRepository userGroupRepository, TaskAssignmentRepository taskAssignmentRepository,
                          TaskCollectionAssignmentRepository taskCollectionAssignmentRepository,
                          TaskCollectionRepository taskCollectionRepository,
                          TaskResultRepository taskResultRepository, TaskRepository taskRepository,
                          PasswordEncoder passwordEncoder, PermissionService permissionService) {
        this.userService = userService;
        this.userRepository = userRepository;
        this.userGroupRepository = userGroupRepository;
        this.taskAssignmentRepository = taskAssignmentRepository;
        this.taskCollectionAssignmentRepository = taskCollectionAssignmentRepository;
        this.taskCollectionRepository = taskCollectionRepository;
        this.taskResultRepository = taskResultRepository;
        this.taskRepository = taskRepository;
        this.passwordEncoder = passwordEncoder;
        this.permissionService = permissionService;
    }

    @GetMapping("/users")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Set<User> getUsers() {
        return userRepository.findAllByDisabled(false);
    }

    @GetMapping("/users/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId" +
            "(authentication,#id)")
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
        user.setPermission(permissionService.updatePermission(null));
        return userRepository.save(user);
    }

    @PutMapping(path = "/users")
    @PreAuthorize("hasAuthority('Teacher') or @userSecurity.hasUserId(authentication,#user.id)")
    public @ResponseBody
    User updateUser(@RequestBody User user) {
        validateUserName(user);
        // we need to set the modifiable properties because if we just save the new user the password and assignments
        // are removed
        User currentUser = getUser(user.getId());
        currentUser.setRole(user.getRole());
        currentUser.setUserName(user.getUserName());
        currentUser.setFullName(user.getFullName());

        // if user updates himself we set the editor to null to avoid that user cannot be removed
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User authorizedUser = userRepository.findByUserName(authentication.getName()).get();
        permissionService.updatePermission(currentUser.getPermission(), user.getId().equals(authorizedUser.getId()));

        return userRepository.save(currentUser);
    }

    /**
     * Checks whether a user with the username already exists or the username contains whitespaces.
     */
    private void validateUserName(User user) {
        if (userRepository.existsByUserNameAndIdNot(user.getUserName(), user.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User with the name %s already " +
                    "exists", user.getUserName()));
        if (user.getUserName().contains(" "))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User name \" %s \" contains " +
                    "whitespaces", user.getUserName()));
    }

    /**
     * Allows changing the password. This method is normally used the first time the user logs in.
     */
    @PutMapping(path = "/users/{id}/updatePassword")
    @PreAuthorize("@userSecurity.hasUserId(authentication,#id)")
    public @ResponseBody
    User updatePassword(@PathVariable Long id, @RequestBody String data) {
        User user = getUser(id);
        ObjectMapper mapper = new ObjectMapper();
        try {
            JsonNode dataJson = mapper.readTree(data);
            if (!dataJson.has("password") || !dataJson.has("securityQuestion") || !dataJson.has("securityAnswer"))
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
            user.setPassword(passwordEncoder.encode(dataJson.get("password").asText()));
            user.setSecurityQuestion(dataJson.get("securityQuestion").asText());
            user.setSecurityAnswer(passwordEncoder.encode(dataJson.get("securityAnswer").asText()));
        } catch (JsonProcessingException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
        }

        user.setPasswordChanged(true);
        return userRepository.save(user);
    }

    /**
     * Disables the user which means the full name and the username are made anonymous and the disabled field is set to
     * true. All task assignments and task results a removed too.
     */
    @PutMapping(path = "/users/{id}/disable")
    @PreAuthorize("hasAuthority('Teacher')")
    public @ResponseBody
    void disableUser(@PathVariable Long id) {
        userService.disableUser(getUser(id));
    }

    /**
     * Returns a custom json object containing the user id and the security question which is needed to reset the user
     * password.
     */
    @GetMapping("/users/{userName}/getSecurityQuestion")
    public String getUser(@PathVariable String userName) throws JsonProcessingException {
        User user = userRepository.findByUserName(userName).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User with the name %s not found",
                        userName)));
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode result = mapper.createObjectNode();
        result.put("userId", user.getId());
        result.put("securityQuestion", user.getSecurityQuestion());
        return mapper.writer().writeValueAsString(result);
    }

    /**
     * Checks whether the given security answer matches the answer given by the user when he set the security question.
     */
    @GetMapping("/users/{id}/validateSecurityAnswer")
    public boolean validateSecurityAnswer(@PathVariable Long id, @RequestBody String securityAnswer) {
        User user = getUser(id);
        return passwordEncoder.matches(securityAnswer, user.getSecurityAnswer());
    }

    /**
     * Checks whether the given security answer matches the answer given by the user when he set the security question.
     */
    @GetMapping("/users/{id}/validatePassword")
    public boolean validatePassword(@PathVariable Long id, @RequestBody String password) {
        User user = getUser(id);
        return passwordEncoder.matches(password, user.getPassword());
    }

    /**
     * Allows updating the password without the even though no user is logged in. Authorization is ensured by the
     * security answer send with the request.
     */
    @PutMapping(path = "/users/{id}/updatePasswordWithSecurityQuestion")
    public @ResponseBody
    User updatePasswordWithSecurityQuestion(@PathVariable Long id, @RequestBody String data) {
        User user = getUser(id);
        ObjectMapper mapper = new ObjectMapper();
        try {
            JsonNode dataJson = mapper.readTree(data);
            if (!dataJson.has("oldSecurityAnswer") || !dataJson.has("password") ||
                    !dataJson.has("securityQuestion") || !dataJson.has("securityAnswer"))
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
            // the current security answer needs to be sent to update the password
            if (!passwordEncoder.matches(dataJson.get("oldSecurityAnswer").asText(), user.getSecurityAnswer()))
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            user.setPassword(passwordEncoder.encode(dataJson.get("password").asText()));
            user.setSecurityQuestion(dataJson.get("securityQuestion").asText());
            user.setSecurityAnswer(passwordEncoder.encode(dataJson.get("securityAnswer").asText()));
        } catch (JsonProcessingException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
        }

        user.setPasswordChanged(true);
        return userRepository.save(user);
    }

    @DeleteMapping(value = "/users/{id}")
    @PreAuthorize("hasAuthority('Teacher') or @userSecurity.hasUserId(authentication,#id)")
    public void deleteUser(@PathVariable Long id) {
        userRepository.deleteById(id);
    }

    @GetMapping("/users/{id}/userGroups")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId" +
            "(authentication,#id)")
    public Set<UserGroup> getUserGroups(@PathVariable Long id) {
        User user = getUser(id);
        return userGroupRepository.findByUsersContaining(user);
    }

    @GetMapping("/users/{id}/taskAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId" +
            "(authentication,#id)")
    public Set<TaskAssignment> getTaskAssignments(@PathVariable Long id) {
        User user = getUser(id);
        return taskAssignmentRepository.findByUser(user);
    }

    /**
     * Only returns task assignments with task results.
     */
    @GetMapping("/users/{id}/taskAssignmentsWithTaskResults")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId" +
            "(authentication,#id)")
    public Set<TaskAssignment> getTaskAssignmentsWithTaskResults(@PathVariable Long id) {
        User user = getUser(id);
        return taskAssignmentRepository.findByUserAndTaskResultsNotNullAndTaskResults_RecordingNotNull(user);
    }

    @GetMapping("/users/{id}/tasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher') or @userSecurity.hasUserId" +
            "(authentication,#id)")
    public Set<Task> getTasks(@PathVariable Long id) {
        User user = getUser(id);
        return taskRepository.findAllByPermission_CreatedBy(user);
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
                                    " id %s not found", id)));
            assignment.setId(null);
            assignment.setUser(user);
            // replace with the task collection from the database to be able to access the permission in the
            // TaskCollectionAssignmentEntityListener
            assignment.setTaskCollection(taskCollection);
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
        if (taskResultRepository.existsByTaskAssignmentId(taskAssignmentId))
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
}
