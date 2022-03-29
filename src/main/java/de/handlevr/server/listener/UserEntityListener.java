package de.handlevr.server.listener;

import de.handlevr.server.domain.User;
import de.handlevr.server.repository.PermissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.PostLoad;

/**
 * Ensures that the editable property of a permission object belonging to a user is reevaluated if the object is fetched
 * from the database. The editableIsDirty property (set in the PermissionEntityListener) indicates that the editable
 * property may have changed.
 */
@Component
public class UserEntityListener {

    private static PermissionRepository permissionRepository;

    @Autowired
    public void setPermissionRepository(PermissionRepository pr) {
        permissionRepository = pr;
    }

    @PostLoad
    private void afterLoad(User user) {
        if (!user.getPermission().isEditableIsDirty())
            return;

        user.getPermission().setEditable(!permissionRepository.existsByCreatedBy(user) && !permissionRepository.existsByLastEditedBy(user));
        user.getPermission().setEditableIsDirty(false);
        permissionRepository.save(user.getPermission());
    }
}
