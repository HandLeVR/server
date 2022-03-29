package de.handlevr.server.controller;

import de.handlevr.server.domain.*;
import de.handlevr.server.repository.*;
import de.handlevr.server.service.PermissionService;
import de.handlevr.server.service.TaskService;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;
import java.util.Set;


/**
 * Handles all task requests.
 */
@RestController
public class TaskController {

    final TaskRepository taskRepository;
    final MediaRepository mediaRepository;
    final CoatRepository coatRepository;
    final UserRepository userRepository;
    final RecordingRepository recordingRepository;
    final WorkpieceRepository workpieceRepository;
    final TaskResultRepository taskResultRepository;
    final TaskAssignmentRepository taskAssignmentRepository;
    final TaskCollectionElementRepository taskCollectionElementRepository;
    final PermissionService permissionService;
    final TaskService taskService;

    public TaskController(TaskRepository taskRepository, MediaRepository mediaRepository,
                          CoatRepository coatRepository, UserRepository userRepository,
                          RecordingRepository recordingRepository, WorkpieceRepository workpieceRepository,
                          TaskResultRepository taskResultRepository,
                          TaskAssignmentRepository taskAssignmentRepository,
                          TaskCollectionElementRepository taskCollectionElementRepository,
                          PermissionService permissionService, TaskService taskService) {
        this.taskRepository = taskRepository;
        this.mediaRepository = mediaRepository;
        this.coatRepository = coatRepository;
        this.userRepository = userRepository;
        this.recordingRepository = recordingRepository;
        this.workpieceRepository = workpieceRepository;
        this.taskResultRepository = taskResultRepository;
        this.taskAssignmentRepository = taskAssignmentRepository;
        this.taskCollectionElementRepository = taskCollectionElementRepository;
        this.permissionService = permissionService;
        this.taskService = taskService;
    }

    @GetMapping("/tasks")
    public List<Task> getTasks() {
        return taskRepository.findAll();
    }

    @GetMapping("/tasks/{id}/media")
    public Set<Media> getUsedMedia(@PathVariable Long id) {
        return mediaRepository.findByUsedInTasksContains(getTask(id));
    }

    @GetMapping("/tasks/{id}")
    public Task getTask(@PathVariable Long id) {
        return taskRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
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
        // cannot remove tasks assigned to user(s)
        if (taskAssignmentRepository.existsByTask(task))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKASSIGNMENT");
        if (taskCollectionElementRepository.existsByTask(task))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKCOLLECTIONELEMENT");
        taskRepository.deleteById(id);
        updateEditableForUsedElements(task);
    }

    /**
     * Update the editable state of the elements used in the task. That means we check whether the element is used
     * somewhere else.
     */
    private void updateEditableForUsedElements(Task task) {
        for (Media media : task.getUsedMedia())
            permissionService.SetEditable(mediaRepository.getOne(media.getId()).getPermission(),
                    media.getUsedInTasks().isEmpty());
        for (Workpiece workpiece : task.getUsedWorkpieces())
            permissionService.SetEditable(workpieceRepository.getOne(workpiece.getId()).getPermission(),
                    workpiece.getUsedInTasks().isEmpty());
        for (Coat coat : task.getUsedCoats())
            permissionService.SetEditable(coatRepository.getOne(coat.getId()).getPermission(),
                    coat.getUsedInTasks().isEmpty());
        for (Recording recording : task.getUsedRecordings())
            permissionService.SetEditable(recordingRepository.getOne(recording.getId()).getPermission(),
                    recording.getUsedInTasks().isEmpty());
    }

    @PutMapping(path = "/tasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Task updateTask(@RequestBody Task task) {
        Task oldTask = getTask(task.getId());
        // cannot update tasks assigned to user(s)
        if (taskResultRepository.existsByTaskAssignment_TaskId(task.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASKRESULT");
        if (taskRepository.existsByNameAndIdNot(task.getName(), task.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        validateUsedElements(task);
        // we rely on the used elements send with the request
        setUsedElementsNotEditable(task);
        task.setPermission(permissionService.updatePermission(oldTask.getPermission()));
        return taskRepository.save(task);
    }

    /**
     * Checks if all elements used in the task exist.
     */
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

    /**
     * Set all elements used in the task to not editable.
     */
    private void setUsedElementsNotEditable(Task task) {
        for (Media media : task.getUsedMedia())
            permissionService.SetEditable(mediaRepository.getOne(media.getId()).getPermission(), false);
        for (Workpiece workpiece : task.getUsedWorkpieces())
            permissionService.SetEditable(workpieceRepository.getOne(workpiece.getId()).getPermission(), false);
        for (Coat coat : task.getUsedCoats())
            permissionService.SetEditable(coatRepository.getOne(coat.getId()).getPermission(), false);
        for (Recording recording : task.getUsedRecordings())
            permissionService.SetEditable(recordingRepository.getOne(recording.getId()).getPermission(), false);
    }

    /**
     * Imports an exported task from a zip file. We always create a new even if there is already a task with the same id
     * or name.
     */
    @PostMapping(path = "/tasks/import")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public List<Task> importTasks(@RequestParam(name = "fileName") String fileName,
                                  @RequestParam(name = "file") MultipartFile file) throws IOException {
        return taskService.importTasks(fileName, file);
    }

    @PostMapping("/tasks")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Task createTask(@RequestBody Task newTask) {
        if (taskRepository.existsByNameAndIdNot(newTask.getName(), newTask.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        validateUsedElements(newTask);
        setUsedElementsNotEditable(newTask);
        newTask.setPermission(permissionService.updatePermission(null));
        newTask.setId(null);
        return taskRepository.save(newTask);
    }
}