package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
public class Workpiece {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    private Permission permission;

    private String name;

    @JsonIgnore
    @ManyToMany(mappedBy = "usedWorkpieces")
    private List<Task> usedInTasks;

    @Column(columnDefinition = "text")
    private String data;
}
