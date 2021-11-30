package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
public class Coat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    private Permission permission;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    private CoatType type;

    private String color;

    private float costs;

    private float solidVolume;

    private String hardenerMixRatio;

    private float thinnerPercentage;

    private float viscosity;

    private String dryingType;

    private float dryingTemperature;

    private int dryingTime;

    private float minSprayDistance;

    private float maxSprayDistance;

    private float glossWet;

    private float glossDry;

    private float targetMinThicknessWet;

    private float targetMaxThicknessWet;

    private float targetMinThicknessDry;

    private float targetMaxThicknessDry;

    private float fullOpacityMinThicknessWet;

    private float fullOpacityMinThicknessDry;

    private float fullGlossMinThicknessWet;

    private float fullGlossMinThicknessDry;

    private float runsStartThicknessWet;

    private float roughness;

    @JsonIgnore
    @ManyToMany(mappedBy = "usedCoats")
    private List<Task> usedInTasks;

    public enum CoatType
    {
        Primer,Basecoat,Clearcoat,Topcoat;
    }
}
