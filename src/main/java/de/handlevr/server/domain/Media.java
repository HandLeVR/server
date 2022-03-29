package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.apache.commons.io.FilenameUtils;

import javax.persistence.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@Data
@Entity
public class Media {

    public final static Path root = Paths.get("Files");
    public final static Path images = Paths.get("Images");
    public final static Path videos = Paths.get("Videos");
    public final static Path audio = Paths.get("Audio");
    public static final Map<MediaType, Path> mediaTypeMap;

    static {
        mediaTypeMap = Map.of(MediaType.Audio, audio, MediaType.Video, videos, MediaType.Image, images);
    }

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
    private MediaType type;
    // contains the path to the media file
    @Column(columnDefinition = "text")
    private String data;
    @JsonIgnore
    @ManyToMany(mappedBy = "usedMedia")
    private List<Task> usedInTasks;

    public Media() {
    }

    /**
     * Updates the data field in dependence of the name of the media element.
     */
    public void updateData() {
        data = mediaTypeMap.get(type).resolve(name + "." + FilenameUtils.getExtension(data)).toString();
    }

    public Path getPath() {
        return root.resolve(data);
    }

    public enum MediaType {
        Video, Image, Audio;
    }
}