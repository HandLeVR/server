package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Data
@Entity
public class TaskCollectionElement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // PostgreSQL does not allow the column name index
    @Column(name = "idx")
    private int index;

    private boolean mandatory;

    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Task task;

    @JsonIgnore
    @ManyToOne
    private TaskCollection taskCollection;
}
