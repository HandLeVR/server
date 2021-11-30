package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import de.handlevr.server.listener.RecordingEntityListener;
import lombok.Data;
import org.apache.commons.io.FilenameUtils;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@Entity
@EntityListeners(RecordingEntityListener.class)
public class Recording {

    public final static Path root = Paths.get("Files");
    public final static Path recordings = Paths.get("Recordings");

    public final static String[] fileEndings = {"_evaluationData.json", "_frames.json", "_preview.png", "_heightmap.png"};

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
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

    // only ignore on serialization because if the client sends a recording we also get a task result
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @OneToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private TaskResult taskResult;

    @JsonIgnore
    @ManyToMany(mappedBy = "usedRecordings")
    private List<Task> usedInTasks;

    public Path getZipPath(){
        return root.resolve(recordings).resolve(name + ".zip");
    }

    public Path getPreviewPath(){
        return root.resolve(recordings).resolve(name + "_preview.png");
    }
}
