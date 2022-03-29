package de.handlevr.server.controller;

import de.handlevr.server.domain.*;
import de.handlevr.server.repository.*;
import de.handlevr.server.service.PermissionService;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Handles all user group request.
 */
@RestController
public class UserGroupController {

    final UserGroupRepository userGroupRepository;
    final UserRepository userRepository;
    final TaskAssignmentRepository taskAssignmentRepository;
    final TaskCollectionAssignmentRepository taskCollectionAssignmentRepository;
    final UserGroupTaskAssignmentRepository userGroupTaskAssignmentRepository;
    final PermissionService permissionService;

    public UserGroupController(UserGroupRepository userGroupRepository, UserRepository userRepository,
                               TaskAssignmentRepository taskAssignmentRepository,
                               TaskCollectionAssignmentRepository taskCollectionAssignmentRepository,
                               UserGroupTaskAssignmentRepository userGroupTaskAssignmentRepository,
                               PermissionService permissionService) {
        this.userGroupRepository = userGroupRepository;
        this.userRepository = userRepository;
        this.taskAssignmentRepository = taskAssignmentRepository;
        this.taskCollectionAssignmentRepository = taskCollectionAssignmentRepository;
        this.userGroupTaskAssignmentRepository = userGroupTaskAssignmentRepository;
        this.permissionService = permissionService;
    }

    @GetMapping("/userGroups")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<UserGroup> getUserGroups() {
        return userGroupRepository.findAll();
    }

    @GetMapping("/userGroups/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public UserGroup getUseGroup(@PathVariable Long id) {
        return userGroupRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User group with the id %s not found"
                        , id)));
    }

    @DeleteMapping("/userGroups/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteUserGroup(@PathVariable Long id) {
        UserGroup userGroup = getUseGroup(id);
        for (UserGroupTaskAssignment assignment : userGroup.getUserGroupTaskAssignments()) {
            removeTaskAssignments(taskAssignmentRepository.findByUserGroupTaskAssignment(assignment), true);
            removeTaskCollectionAssignments(taskCollectionAssignmentRepository.findByUserGroupTaskAssignment(assignment), true);
        }
        userGroupRepository.delete(userGroup);
    }

    @PutMapping(path = "/userGroups")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public UserGroup updateUserGroup(@RequestBody UserGroup userGroup) {
        UserGroup oldUserGroup = getUseGroup(userGroup.getId());
        if (userGroupRepository.existsByNameAndIdNot(userGroup.getName(), userGroup.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User group with the name %s already" +
                    " exists", userGroup.getName()));
        oldUserGroup.setName(userGroup.getName());
        permissionService.updatePermission(oldUserGroup.getPermission());
        return userGroupRepository.save(oldUserGroup);
    }

    @PostMapping("/userGroups")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public UserGroup createUserGroup(@RequestBody UserGroup userGroup) {
        if (userGroupRepository.existsByNameAndIdNot(userGroup.getName(), userGroup.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User group with the name %s already" +
                    " exists", userGroup.getName()));
        userGroup.setId(null);
        userGroup.setPermission(permissionService.updatePermission(null));
        return userGroupRepository.save(userGroup);
    }

    @GetMapping("/userGroups/{id}/userGroupTaskAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Set<UserGroupTaskAssignment> getUserGroupTaskAssignments(@PathVariable Long id) {
        UserGroup userGroup = getUseGroup(id);
        return userGroupTaskAssignmentRepository.findByUserGroup(userGroup);
    }

    @PostMapping("/userGroups/{id}/userGroupTaskAssignments")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<UserGroupTaskAssignment> addUserGroupTaskAssignment(@PathVariable Long id,
                                                                    @RequestBody List<UserGroupTaskAssignment> assignments) {
        UserGroup userGroup = getUseGroup(id);
        List<UserGroupTaskAssignment> result = new ArrayList<>();
        for (UserGroupTaskAssignment assignment : assignments) {
            assignment.setUserGroup(userGroup);
            assignment = userGroupTaskAssignmentRepository.save(assignment);
            for (User user : userGroup.getUsers())
                createAssignmentsForUser(user, assignment);
            result.add(assignment);
        }

        return result;
    }

    @DeleteMapping(value = "/userGroups/{userGroupId}/userGroupTaskAssignments/{assignmentId}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteUserGroupTaskAssignments(@PathVariable Long userGroupId, @PathVariable Long assignmentId) {
        getUseGroup(userGroupId);
        UserGroupTaskAssignment assignment = userGroupTaskAssignmentRepository.findById(assignmentId).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User group task assignment with the " +
                        "id %s not found", assignmentId)));
        if (!userGroupId.equals(assignment.getUserGroup().getId()))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User group task assignment with " +
                    "the id %s is not assigned to the given user group", assignmentId));
        removeTaskAssignments(taskAssignmentRepository.findByUserGroupTaskAssignment(assignment), true);
        removeTaskCollectionAssignments(taskCollectionAssignmentRepository.findByUserGroupTaskAssignment(assignment),
                true);
        userGroupTaskAssignmentRepository.delete(assignment);
    }

    /**
     * Adds a user to the group without assigning the tasks assigned to the group.
     */
    @PostMapping("/userGroups/{userGroupId}/users")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public UserGroup addUser(@PathVariable Long userGroupId, @RequestBody User user) {
        return addUser(userGroupId, user, false);
    }

    /**
     * Adds a user to the group and assigns all tasks to him assigned to the group.
     */
    @PostMapping("/userGroups/{userGroupId}/users/addTasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public UserGroup addUserWithTasks(@PathVariable Long userGroupId, @RequestBody User user) {
        return addUser(userGroupId, user, true);
    }

    /**
     * Deletes a user from a group and converts all assignments for this user originating from the group to direct
     * assignments.
     */
    @DeleteMapping(value = "/userGroups/{userGroupId}/users/{userId}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteUser(@PathVariable Long userGroupId, @PathVariable Long userId) {
        deleteUser(userGroupId, userId, false);
    }

    /**
     * Deletes a user from a group and removes all assignments for this user originating from the group.
     */
    @DeleteMapping(value = "/userGroups/{userGroupId}/users/{userId}/removeTasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteUserWithTasks(@PathVariable Long userGroupId, @PathVariable Long userId) {
        deleteUser(userGroupId, userId, true);
    }

    /**
     * Adds a user to the group
     */
    private UserGroup addUser(Long userGroupId, User user, boolean addTasks) {
        UserGroup userGroup = getUseGroup(userGroupId);
        user = getUser(user.getId());
        if (userGroup.getUsers().contains(user))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User with the id %s is " +
                    "already in group with the id %s", user.getId(), userGroupId));
        userGroup.getUsers().add(user);
        userGroup = userGroupRepository.save(userGroup);
        if (!addTasks)
            return userGroup;
        for (UserGroupTaskAssignment assignment : userGroup.getUserGroupTaskAssignments()) {
            createAssignmentsForUser(user, assignment);
        }
        permissionService.updatePermission(userGroup.getPermission());
        return userGroup;
    }

    /**
     * Creates individual task assignments for the user.
     */
    private void createAssignmentsForUser(User user, UserGroupTaskAssignment assignment) {
        if (assignment.getTask() != null)
            taskAssignmentRepository.save(new TaskAssignment(user, assignment.getTask(), null, assignment,
                    assignment.getDeadline()));
        else {
            TaskCollectionAssignment taskCollectionAssignment =
                    taskCollectionAssignmentRepository.save(new TaskCollectionAssignment(user,
                            assignment.getTaskCollection(), assignment, assignment.getDeadline()));
            for (TaskCollectionElement element : assignment.getTaskCollection().getTaskCollectionElements()) {
                taskAssignmentRepository.save(new TaskAssignment(user, element.getTask(),
                        taskCollectionAssignment, assignment, assignment.getDeadline()));
            }
        }
    }

    /**
     * Deletes the user and removes all assignments if needed.
     */
    private void deleteUser(Long userGroupId, Long userId, boolean removeAssignments) {
        UserGroup userGroup = getUseGroup(userGroupId);
        User user = getUser(userId);
        if (!userGroup.getUsers().contains(user))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("User with the id %s not in the " +
                    "group with the id %s", userId, userGroupId));
        for (UserGroupTaskAssignment assignment : userGroup.getUserGroupTaskAssignments()) {
            removeTaskAssignments(taskAssignmentRepository.findByUserAndUserGroupTaskAssignment(user, assignment),
                    removeAssignments);
            removeTaskCollectionAssignments(taskCollectionAssignmentRepository.findByUserAndUserGroupTaskAssignment(user, assignment), removeAssignments);
        }
        userGroup.getUsers().remove(user);
        permissionService.updatePermission(userGroup.getPermission());
        userGroupRepository.save(userGroup);
    }

    private void removeTaskAssignments(Set<TaskAssignment> taskAssignments, boolean removeAssignments) {
        for (TaskAssignment taskAssignment : taskAssignments) {
            if (removeAssignments && taskAssignment.getTaskResults().isEmpty())
                taskAssignmentRepository.delete(taskAssignment);
            else {
                taskAssignment.setUserGroupTaskAssignment(null);
                taskAssignmentRepository.save(taskAssignment);
            }
        }
    }

    private void removeTaskCollectionAssignments(Set<TaskCollectionAssignment> taskCollectionAssignments,
                                                 boolean removeAssignments) {
        for (TaskCollectionAssignment taskCollectionAssignment : taskCollectionAssignments) {
            if (removeAssignments)
                taskCollectionAssignmentRepository.delete(taskCollectionAssignment);
            else {
                taskCollectionAssignment.setUserGroupTaskAssignment(null);
                taskCollectionAssignmentRepository.save(taskCollectionAssignment);
            }
        }
    }

    private User getUser(Long id) {
        return userRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("User with the id %s not found", id)));
    }
}
