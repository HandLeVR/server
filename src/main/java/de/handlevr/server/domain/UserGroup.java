package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
public class UserGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToMany
    @JoinTable
    private List<User> users;

    @JsonIgnore
    @OneToMany(mappedBy = "userGroup", cascade = CascadeType.REMOVE)
    private List<UserGroupTaskAssignment> userGroupTaskAssignments;
}
