package de.handlevr.server.listener;

import de.handlevr.server.domain.Permission;
import de.handlevr.server.domain.TaskCollectionAssignment;
import de.handlevr.server.repository.PermissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostPersist;
import javax.persistence.PreRemove;

/**
 * Ensures that the editable property of a permission belonging to a task collection gets updated if the task
 * collection is assigned to a user or group, or revoked.
 */
@Component
public class TaskCollectionAssignmentEntityListener {

    private static PermissionRepository permissionRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    /**
     * Sets the editable property of a permission object belonging to a task collection to false if the task collection
     * is assigned to a user or group.
     */
    @PostPersist
    private void afterCreation(TaskCollectionAssignment taskCollectionAssignment) {
        Permission permissionToUpdate = taskCollectionAssignment.getTaskCollection().getPermission();
        permissionToUpdate.setEditable(false);
        permissionToUpdate.setEditableIsDirty(false);
        permissionRepository.save(permissionToUpdate);
    }

    /**
     * Sets the editableIsDirty property of a permission object belonging to a task collection to true if an
     * assignment of the collection is revoked. The TaskCollectionEntityListener then knows that the editable property
     * needs to be reevaluated if the task collection is fetched.
     */
    @PreRemove
    private void beforeRemove(TaskCollectionAssignment taskCollectionAssignment) {
        Permission permissionToUpdate = taskCollectionAssignment.getTaskCollection().getPermission();
        permissionToUpdate.setEditableIsDirty(true);
        permissionRepository.save(permissionToUpdate);
    }
}
