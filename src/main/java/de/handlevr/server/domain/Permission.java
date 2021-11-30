package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.Data;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.util.Objects;

@Data
@Entity
public class Permission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /*
    GET only returns authorId,
    PUT and POST work with only authorId as well
    This is to avoid infinite recursion
     */
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    @JsonProperty("authorId")
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "author_id", nullable = true)
    @OnDelete(action = OnDeleteAction.NO_ACTION) //When Author is deleted, delete authored elements as well?
    private User author;

    private boolean visible;

    private boolean editable;

    public Permission() {
    }
}
