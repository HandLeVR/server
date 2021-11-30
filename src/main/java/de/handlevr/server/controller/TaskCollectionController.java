package de.handlevr.server.controller;

import de.handlevr.server.domain.*;
import de.handlevr.server.repository.TaskCollectionAssignmentRepository;
import de.handlevr.server.repository.TaskCollectionElementRepository;
import de.handlevr.server.repository.TaskCollectionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@RestController
public class TaskCollectionController {

    @Autowired
    TaskCollectionRepository taskCollectionRepository;
    @Autowired
    TaskCollectionElementRepository taskCollectionElementRepository;
    @Autowired
    TaskCollectionAssignmentRepository taskCollectionAssignmentRepository;

    @GetMapping("/taskCollections")
    public List<TaskCollection> getTaskCollections() {
        return taskCollectionRepository.findAll();
    }

    @GetMapping("/taskCollections/{id}")
    public TaskCollection getTaskCollection(@PathVariable Long id) {
        return taskCollectionRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Task collection with the id %s not " +
                        "found", id)));
    }

    @GetMapping("/taskCollections/{id}/taskCollectionAssignments")
    public Set<TaskCollectionAssignment> getTaskCollectionAssignments(@PathVariable Long id) {
        TaskCollection taskCollection = getTaskCollection(id);
        return taskCollectionAssignmentRepository.findByTaskCollection(taskCollection);
    }

    @DeleteMapping("/taskCollections/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteTaskCollection(@PathVariable Long id) {
        TaskCollection taskCollection = getTaskCollection(id);
        if (taskCollectionAssignmentRepository.existsByTaskCollection(taskCollection))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("Task collection with the id %s already has task assignments", taskCollection.getId()));
        taskCollectionRepository.deleteById(id);
    }

    @PutMapping(path = "/taskCollections")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public TaskCollection updateTaskCollection(@RequestBody TaskCollection taskCollection) {
        return handleTaskCollection(taskCollection);
    }

    @PostMapping("/taskCollections")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public TaskCollection createTaskCollection(@RequestBody TaskCollection taskCollection) {
        taskCollection.setId(null);
        return handleTaskCollection(taskCollection);
    }

    /**
     * Manually handles the task collection elements because cascading did not work.
     */
    private TaskCollection handleTaskCollection(TaskCollection taskCollection) {
        if (taskCollectionRepository.existsByNameAndIdNot(taskCollection.getName(), taskCollection.getId() != null ?
                taskCollection.getId() : -1))
            throw new ResponseStatusException(HttpStatus.CONFLICT, String.format("Task collection with the name %s " +
                    "already exists", taskCollection.getName()));
        List<TaskCollectionElement> elements = taskCollection.getTaskCollectionElements();
        taskCollection.setTaskCollectionElements(new ArrayList<>());
        TaskCollection updatedTaskCollection = taskCollectionRepository.save(taskCollection);
        for (TaskCollectionElement element : elements) {
            element.setTaskCollection(updatedTaskCollection);
            taskCollectionElementRepository.save(element);
            updatedTaskCollection.getTaskCollectionElements().add(element);
        }
        return updatedTaskCollection;
    }
}
