package net.lerkasan.capstone.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

import static jakarta.persistence.CascadeType.*;

@Entity
@Table(name = "topics")
@Getter
@Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
@RequiredArgsConstructor
@EqualsAndHashCode(of = {"id", "name"})
@ToString(exclude = {"interviews"})
public class Topic {

    public static final String NAME_FIELD_IS_REQUIRED = "Name field is required.";
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NonNull
    @NotBlank(message = NAME_FIELD_IS_REQUIRED)
    @Size(min = 3, max = 500)
    @Column(name = "name", nullable = false, length = 500)
    private String name;

    @ManyToOne
    @PrimaryKeyJoinColumn(name="category_id", referencedColumnName="id")
    @JsonIgnoreProperties(value = {"topics"})
    private Category category;

    @OneToMany(mappedBy = "topic", cascade = {PERSIST, MERGE, REFRESH, DETACH}, fetch = FetchType.LAZY)
    @OrderBy(value = "id ASC")
    @JsonIgnore
    private Set<Interview> interviews = new HashSet<>();

}