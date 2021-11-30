package de.handlevr.server.domain;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/*
 * Represents a painting task.
 *
 * The annotation @JsonIgnore for users is needed to break the cycle when serializing the object
 */
@Data
@Entity
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    private Permission permission;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    private TaskClass taskClass;

    @Column(columnDefinition = "text")
    private String subTasks;

    private boolean partTaskPractice;

    private boolean valuesMissing;

    @ManyToMany
    @JoinTable
    private Set<Coat> usedCoats;

    @ManyToMany
    @JoinTable
    private Set<Recording> usedRecordings;

    @ManyToMany
    @JoinTable
    private Set<Media> usedMedia;

    @ManyToMany
    @JoinTable
    private Set<Workpiece> usedWorkpieces;

    public enum TaskClass {
        NewPartPainting, RefinishingJob, SpotRepair
    }
}
