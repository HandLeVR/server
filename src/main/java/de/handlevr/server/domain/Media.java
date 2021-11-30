package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.apache.commons.io.FilenameUtils;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Data
@Entity
public class Media {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    private Permission permission;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    private MediaType type;

    @Column(columnDefinition = "text")
    private String data;

    @JsonIgnore
    @ManyToMany(mappedBy = "usedMedia")
    private List<Task> usedInTasks;

    public Media() {
    }

    public final static Path root = Paths.get("Files");
    public final static Path images = Paths.get("Images");
    public final static Path videos = Paths.get("Videos");
    public final static Path audio = Paths.get("Audio");

    public static final Map<MediaType, Path> mediaTypeMap;

    static {
        Map<Media.MediaType, Path> aMap = new HashMap<>();
        aMap.put(Media.MediaType.Audio, audio);
        aMap.put(Media.MediaType.Video, videos);
        aMap.put(Media.MediaType.Image, images);
        mediaTypeMap = Collections.unmodifiableMap(aMap);
    }

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
