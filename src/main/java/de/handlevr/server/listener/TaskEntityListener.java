package de.handlevr.server.listener;

import de.handlevr.server.domain.Task;
import de.handlevr.server.repository.PermissionRepository;
import de.handlevr.server.repository.TaskResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostLoad;

/**
 * Ensures the editable field of the permission object belonging to a tasks is updated if needed. A task is not editable
 * if a result exists for this task.
 */
@Component
public class TaskEntityListener {

    private static PermissionRepository permissionRepository;
    private static TaskResultRepository taskResultRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    @Autowired
    public void setTaskResultRepository(TaskResultRepository tr) {
        taskResultRepository = tr;
    }

    @PostLoad
    private void afterLoad(Task task) {
        if (!task.getPermission().isEditableIsDirty())
            return;

        task.getPermission().setEditable(taskResultRepository.existsByTaskAssignment_TaskId(task.getId()));
        task.getPermission().setEditableIsDirty(false);
        permissionRepository.save(task.getPermission());
    }
}
