package de.handlevr.server.domain;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Represents an assignment of a task to a user. A task assignment is created for every directly assigned task and also
 * for every task assigned through a task collection assignment or a user group task assignment.
 */
@Data
@Entity
public class TaskAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Task task;

    // the corresponding task collection assignment if this is not a directly assigned task
    @ManyToOne
    private TaskCollectionAssignment taskCollectionAssignment;

    // the corresponding user group task assignment if this is not a directly assigned task
    @ManyToOne
    private UserGroupTaskAssignment userGroupTaskAssignment;

    @OneToMany(mappedBy = "taskAssignment", cascade = CascadeType.REMOVE)
    private List<TaskResult> taskResults;

    private Date deadline;

    public TaskAssignment() {
    }

    public TaskAssignment(User user, Task task, TaskCollectionAssignment taskCollectionAssignment,
                          UserGroupTaskAssignment userGroupTaskAssignment, Date deadline) {
        this.user = user;
        this.task = task;
        this.taskCollectionAssignment = taskCollectionAssignment;
        this.userGroupTaskAssignment = userGroupTaskAssignment;
        this.deadline = deadline;
    }
}
