package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import de.handlevr.server.listener.TaskCollectionEntityListener;
import de.handlevr.server.listener.TaskEntityListener;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * Represents a painting task.
 *
 */
@Data
@Entity
@EntityListeners(TaskEntityListener.class)
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Permission permission;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    private TaskClass taskClass;

    @Column(columnDefinition = "text")
    private String subTasks;

    private boolean partTaskPractice;

    // indicates whether some needed values are set which means that the task cannot be solved yet
    private boolean valuesMissing;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable
    private Set<Coat> usedCoats;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable
    private Set<Recording> usedRecordings;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable
    private Set<Media> usedMedia;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable
    private Set<Workpiece> usedWorkpieces;

    public enum TaskClass {
        NewPartPainting, RefinishingJob, SpotRepair
    }
}
