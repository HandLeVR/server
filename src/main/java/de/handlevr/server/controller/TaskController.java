package de.handlevr.server.controller;

import de.handlevr.server.domain.*;
import de.handlevr.server.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Set;

@RestController
public class TaskController {

    @Autowired
    TaskRepository taskRepository;
    @Autowired
    MediaRepository mediaRepository;
    @Autowired
    CoatRepository coatRepository;
    @Autowired
    RecordingRepository recordingRepository;
    @Autowired
    WorkpieceRepository workpieceRepository;
    @Autowired
    TaskResultRepository taskResultRepository;
    @Autowired
    TaskAssignmentRepository taskAssignmentRepository;
    @Autowired
    TaskCollectionElementRepository taskCollectionElementRepository;

    @GetMapping("/tasks")
    public List<Task> getTasks() {
        return taskRepository.findAll();
    }

    @GetMapping("/tasks/{id}")
    public Task getTask(@PathVariable Long id) {
        Task task = taskRepository.findById(id).orElseThrow(() ->  new ResponseStatusException(HttpStatus.NOT_FOUND));
        // TODO: permission vollständig nutzen
        Permission permission = new Permission();
        permission.setId(0l);
        permission.setEditable(taskResultRepository.findFirstByTaskAssignment_TaskId(task.getId()) == null);
        task.setPermission(permission);
        return task;
    }

    @GetMapping("/tasks/{id}/media")
    public Set<Media> getUsedMedia(@PathVariable Long id) {
        return mediaRepository.findByUsedInTasksContains(getTask(id));
    }

    @GetMapping("/tasks/{id}/recordings")
    public Set<Recording> getUsedRecordings(@PathVariable Long id) {
        return recordingRepository.findByUsedInTasksContains(getTask(id));
    }

    @GetMapping("/tasks/{id}/workpieces")
    public Set<Workpiece> getUsedWorkpieces(@PathVariable Long id) {
        return workpieceRepository.findByUsedInTasksContains(getTask(id));
    }

    @GetMapping("/tasks/{id}/coats")
    public Set<Coat> getUsedCoats(@PathVariable Long id) {
        return coatRepository.findByUsedInTasksContains(getTask(id));
    }

    @DeleteMapping("/tasks/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteTask(@PathVariable Long id) {
        Task task = getTask(id);
        if (taskAssignmentRepository.findFirstByTask(task) != null)
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKASSIGNMENT");
        if (taskCollectionElementRepository.findFirstByTask(task) != null)
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKCOLLECTIONELEMENT");
        // TODO: temporary solution for the permission created in getTask
        task.setPermission(null);
        taskRepository.deleteById(id);
    }

    @PutMapping(path = "/tasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Task updateTask(@RequestBody Task task) {
        if (taskResultRepository.findFirstByTaskAssignment_TaskId(task.getId()) != null)
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKRESULT");
        if (taskRepository.existsByNameAndIdNot(task.getName(), task.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        validateUsedElements(task);
        return taskRepository.save(task);
    }

    @PostMapping("/tasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Task createTask(@RequestBody Task newTask) {
        if (taskRepository.existsByNameAndIdNot(newTask.getName(), newTask.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        validateUsedElements(newTask);
        newTask.setId(null);
        return taskRepository.save(newTask);
    }

    private void validateUsedElements(Task task) {
        for (Media media : task.getUsedMedia())
            if (!mediaRepository.existsById(media.getId()))
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, media.getName());
        for (Workpiece workpiece : task.getUsedWorkpieces())
            if (!workpieceRepository.existsById(workpiece.getId()))
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, workpiece.getName());
        for (Coat coat : task.getUsedCoats())
            if (!coatRepository.existsById(coat.getId()))
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, coat.getName());
        for (Recording recording : task.getUsedRecordings())
            if (!recordingRepository.existsById(recording.getId()))
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, recording.getName());
    }
}
