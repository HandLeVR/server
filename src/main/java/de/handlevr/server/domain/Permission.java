package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import de.handlevr.server.listener.PermissionEntityListener;
import lombok.Data;
import org.hibernate.Hibernate;

import javax.persistence.*;
import java.util.Date;
import java.util.Objects;

/**
 * Contains additional information about elements that can be created by users.
 */
@Data
@Entity
@EntityListeners(PermissionEntityListener.class)
public class Permission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "fullName")
    @JsonIdentityReference(alwaysAsId = true)
    @JsonProperty("createdByFullName")
    private User createdBy;

    private Date createdDate;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "fullName")
    @JsonIdentityReference(alwaysAsId = true)
    @JsonProperty("lastEditedByFullName")
    private User lastEditedBy;

    private Date lastEditedDate;

    // indicates whether the connected element is editable or deletable (depends on the element)
    private boolean editable;

    // indicates whether the editable field may have changed and needs to be updated
    private boolean editableIsDirty;

    public Permission() {
    }

    public Permission(Long id, User createdBy, Date createdDate, User lastEditedBy, Date lastEditedDate,
                      boolean editable) {
        this.id = id;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.lastEditedBy = lastEditedBy;
        this.lastEditedDate = lastEditedDate;
        this.editable = editable;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        Permission that = (Permission) o;
        return id != null && Objects.equals(id, that.id);
    }

    /**
     * Needed to avoid error message "Fail-safe cleanup (collections)".
     * Source: https://stackoverflow.com/questions/53540056/what-causes-spring-boot-fail-safe-cleanup-collections-to-occur
     */
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
