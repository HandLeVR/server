package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Represents assignments of tasks or task collections to user groups.
 */
@Data
@Entity
public class UserGroupTaskAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private UserGroup userGroup;

    @ManyToOne
    private Task task;

    @ManyToOne
    private TaskCollection taskCollection;

    private Date deadline;

    @JsonIgnore
    @OneToMany(mappedBy = "userGroupTaskAssignment")
    private List<TaskCollectionAssignment> taskCollectionAssignments;

    @JsonIgnore
    @OneToMany(mappedBy = "userGroupTaskAssignment")
    private List<TaskAssignment> taskAssignments;

    @PreRemove
    private void preRemove() {
        for (TaskAssignment taskAssignment : taskAssignments)
            taskAssignment.setUserGroupTaskAssignment(null);
        for (TaskCollectionAssignment taskCollectionAssignment : taskCollectionAssignments)
            taskCollectionAssignment.setUserGroupTaskAssignment(null);
    }
}
