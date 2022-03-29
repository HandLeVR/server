package de.handlevr.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import de.handlevr.server.listener.UserEntityListener;
import lombok.Data;

import javax.persistence.*;
import javax.persistence.Entity;
import java.util.List;

/**
 * Representation of a user.
 */
@Data
@Entity
@Table(name = "user", schema = "public")
@EntityListeners(UserEntityListener.class)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = CascadeType.ALL)
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Permission permission;

    private String userName;

    private String fullName;

    // PostgreSQL does not allow the column name password
    @Column(name = "pwd")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    private String securityQuestion;

    @JsonIgnore
    private String securityAnswer;

    @Enumerated(EnumType.STRING)
    private Role role;

    private boolean passwordChanged;

    @JsonIgnore
    private boolean disabled;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<TaskAssignment> taskAssignments;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<TaskCollectionAssignment> taskCollectionAssignments;

    @JsonIgnore
    @ManyToMany(mappedBy = "users")
    private List<UserGroup> userGroups;

    public User() {
    }

    public User(String name, String password) {
        this.userName = name;
        this.password = password;
    }

    @PreRemove
    private void preRemove(){
        for (UserGroup userGroup : userGroups) {
            userGroup.getUsers().remove(this);
        }
    }

    public enum Role
    {
        Learner, RestrictedTeacher, Teacher
    }
}

