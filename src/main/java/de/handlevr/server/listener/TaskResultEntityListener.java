package de.handlevr.server.listener;

import de.handlevr.server.domain.Permission;
import de.handlevr.server.domain.Task;
import de.handlevr.server.domain.TaskResult;
import de.handlevr.server.repository.PermissionRepository;
import de.handlevr.server.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostPersist;
import javax.persistence.PreRemove;
import java.util.Optional;

/*
 * Handles task result requests.
 */
@Component
public class TaskResultEntityListener {

    private static PermissionRepository permissionRepository;

    private static TaskRepository taskRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    @Autowired
    public void setTaskRepository(TaskRepository tr) {
        taskRepository = tr;
    }

    @PostPersist
    private void afterCreation(TaskResult taskResult) {
        Optional<Task> task = taskRepository.findById(taskResult.getTaskAssignment().getTask().getId());
        if (task.isPresent()) {
            task.get().getPermission().setEditable(false);
            permissionRepository.save(task.get().getPermission());
        }
    }

    @PreRemove
    private void beforeRemove(TaskResult taskResult) {
        Permission permissionToUpdate = taskResult.getTaskAssignment().getTask().getPermission();
        permissionToUpdate.setEditableIsDirty(true);
        permissionRepository.save(permissionToUpdate);
    }
}
