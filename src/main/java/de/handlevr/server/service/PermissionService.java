package de.handlevr.server.service;

import de.handlevr.server.domain.Permission;
import de.handlevr.server.domain.User;
import de.handlevr.server.repository.PermissionRepository;
import de.handlevr.server.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * Provides methods to modify permission objects.
 */
@Service("permissionService")
public class PermissionService {

    private final UserRepository userRepository;
    private final PermissionRepository permissionRepository;

    @Autowired
    public PermissionService(UserRepository userRepository, PermissionRepository permissionRepository) {
        this.userRepository = userRepository;
        this.permissionRepository = permissionRepository;
    }

    public Permission updatePermission(Permission permission) {
        return updatePermission(permission, false);
    }

    public Permission updatePermission(Permission permission, boolean anonymous) {
        User user = null;
        if (!anonymous) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            user = userRepository.findByUserName(authentication.getName()).get();
        }
        Permission perm = permission;
        if (perm == null) {
            perm = new Permission();
            perm.setCreatedBy(user);
            perm.setCreatedDate(new Date());
            perm.setEditable(true);
        }
        perm.setLastEditedBy(user);
        perm.setLastEditedDate(new Date());
        permissionRepository.save(perm);
        return perm;
    }

    public void SetEditable(Permission permission, boolean editable) {
        if (permission.isEditable() == editable)
            return;
        permission.setEditable(editable);
        permissionRepository.save(permission);
    }
}
