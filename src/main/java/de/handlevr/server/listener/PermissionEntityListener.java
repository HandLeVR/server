package de.handlevr.server.listener;

import de.handlevr.server.domain.Permission;
import de.handlevr.server.repository.PermissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostPersist;
import javax.persistence.PostUpdate;
import javax.persistence.PreRemove;

/**
 * A user cannot be removed after he created or modified an element (e.g. media, task or recording). This Listener
 * ensures that the permission object belonging to a user is updated if an element is created, modified or removed by
 * the user.
 */
@Component
public class PermissionEntityListener {

    private static PermissionRepository permissionRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    /**
     * Sets the editable property of the permission object of a user to false if the user created an element.
     */
    @PostPersist
    private void afterCreation(Permission permission) {
        if (permission.getCreatedBy() == null)
            return;

        Permission permissionToUpdate = permission.getCreatedBy().getPermission();
        permissionToUpdate.setEditable(false);
        permissionToUpdate.setEditableIsDirty(false);
        permissionRepository.save(permissionToUpdate);
    }

    /**
     * Sets the editable property of the permission object of a user to false if the user modified an element.
     */
    @PostUpdate
    private void afterUpdate(Permission permission) {
        if (permission.getLastEditedBy() == null)
            return;

        Permission permissionToUpdate = permission.getLastEditedBy().getPermission();
        permissionToUpdate.setEditable(false);
        permissionToUpdate.setEditableIsDirty(false);
        permissionRepository.save(permissionToUpdate);
    }

    /**
     * Sets the editableIsDirty property of the permission object of the author of an element false if it was removed.
     * Then we now that we need to reevaluate whether the author is removable (done in the UserEntityListener) the next
     * time the author is fetched.
     *
     * It was not possible to set the editable property directly (StaleStateException).
     * @PostRemove also didn't work (changes were not saved).
     */
    @PreRemove
    private void beforeRemove(Permission permission) {
        if (permission.getCreatedBy() == null || permission.getLastEditedBy() == null)
            return;

        Permission permissionToUpdate = permission.getCreatedBy().getPermission();
        permissionToUpdate.setEditableIsDirty(true);
        permissionRepository.save(permissionToUpdate);
        permissionToUpdate = permission.getLastEditedBy().getPermission();
        permissionToUpdate.setEditableIsDirty(true);
        permissionRepository.save(permissionToUpdate);
    }

}
