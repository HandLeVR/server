package de.handlevr.server.domain;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonProperty;
import de.handlevr.server.listener.TaskResultEntityListener;
import lombok.Data;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.Entity;
import java.util.Date;

@Data
@Entity
@EntityListeners(TaskResultEntityListener.class)
public class TaskResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Date date;

    // only ignore on serialization because if the client sends a recording we also
    // get a task result containing task assignment
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @ManyToOne(optional = false)
    private TaskAssignment taskAssignment;

    @OneToOne(cascade = CascadeType.REMOVE)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Recording recording;
}