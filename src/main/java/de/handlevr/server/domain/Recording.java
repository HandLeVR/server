package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import de.handlevr.server.listener.RecordingEntityListener;
import lombok.Data;

import javax.persistence.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

/**
 * Represents a recording of a paint application.
 */
@Data
@Entity
@EntityListeners(RecordingEntityListener.class)
public class Recording {

    public final static Path rootPath = Paths.get("Files");
    public final static Path recordingsPath = Paths.get("Recordings");
    public final static Path taskResultsPath = Paths.get("TaskResults");

    public final static String[] fileEndings = {"_evaluationData.json", "_frames.json", "_preview.png", "_heightmap" +
            ".png"};

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Permission permission;

    private String hash;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    private Date date;

    private float neededTime;

    @ManyToOne
    private Workpiece workpiece;

    @ManyToOne
    private Coat coat;

    @ManyToOne
    private Coat baseCoat;

    @Column(columnDefinition = "text")
    private String data;

    // only needed on server side
    @JsonIgnore
    private boolean hasTaskResult;

    // don't map task result to the database to avoid mutual dependency
    @Transient
    private TaskResult taskResult;

    @JsonIgnore
    @ManyToMany(mappedBy = "usedRecordings")
    private List<Task> usedInTasks;

    public Path getZipPath() {
        return rootPath.resolve(hasTaskResult ? taskResultsPath : recordingsPath).resolve(name + ".zip");
    }

    public Path getPreviewPath() {
        return rootPath.resolve(hasTaskResult ? taskResultsPath : recordingsPath).resolve(name + "_preview.png");
    }
}
