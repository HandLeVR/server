package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
public class TaskCollection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    private Permission permission;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    private Task.TaskClass taskClass;

    @OneToMany(mappedBy = "taskCollection", orphanRemoval = true)
    private List<TaskCollectionElement> taskCollectionElements;

    @JsonIgnore
    @OneToMany(mappedBy = "taskCollection")
    private List<TaskCollectionAssignment> taskCollectionAssignments;

    public TaskCollection() {
    }
}

