package de.handlevr.server.domain;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

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

    @ManyToOne
    private TaskCollectionAssignment taskCollectionAssignment;

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
