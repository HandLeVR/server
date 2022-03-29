package de.handlevr.server.listener;

import de.handlevr.server.domain.TaskCollection;
import de.handlevr.server.repository.PermissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostLoad;

/**
 * Reevaluates the editable property of a permission object belonging to a task collection if the task collection is
 * fetched and editableIsDirty is true (set in the TaskCollectionAssignmentEntityListener).
 */
@Component
public class TaskCollectionEntityListener {

    private static PermissionRepository permissionRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    @PostLoad
    private void afterLoad(TaskCollection taskCollection) {
        if (!taskCollection.getPermission().isEditableIsDirty())
            return;

        taskCollection.getPermission().setEditable(taskCollection.getTaskCollectionAssignments().isEmpty());
        taskCollection.getPermission().setEditableIsDirty(false);
        permissionRepository.save(taskCollection.getPermission());
    }
}
