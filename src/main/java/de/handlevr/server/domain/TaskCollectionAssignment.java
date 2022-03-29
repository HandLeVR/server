package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import de.handlevr.server.listener.TaskCollectionAssignmentEntityListener;
import lombok.Data;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Represents an assignment of a task collection to a user. Is also created if a task collection is assigned through a
 * user group task assignment.
 */
@Data
@Entity
@EntityListeners(TaskCollectionAssignmentEntityListener.class)
public class TaskCollectionAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private TaskCollection taskCollection;

    // the corresponding user group task assignment if this is not a directly assigned task collection
    @ManyToOne
    private UserGroupTaskAssignment userGroupTaskAssignment;

    private Date deadline;

    @JsonIgnore
    @OneToMany(mappedBy = "taskCollectionAssignment")
    private List<TaskAssignment> taskAssignments;

    public TaskCollectionAssignment() {
    }

    public TaskCollectionAssignment(User user, TaskCollection taskCollection,
                                    UserGroupTaskAssignment userGroupTaskAssignment, Date deadline) {
        this.user = user;
        this.taskCollection = taskCollection;
        this.userGroupTaskAssignment = userGroupTaskAssignment;
        this.deadline = deadline;
    }

    @PreRemove
    private void preRemove() {
        for (TaskAssignment taskAssignment : taskAssignments) {
            taskAssignment.setTaskCollectionAssignment(null);
        }
    }
}
