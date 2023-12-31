package net.lerkasan.capstone.repository;

import net.lerkasan.capstone.model.Interview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InterviewRepository extends JpaRepository<Interview, Long> {

    final String AVERAGE_SCORE_QUERY = "SELECT avg(f.score) FROM Interview i LEFT JOIN i.questions q LEFT JOIN q.answers a LEFT JOIN a.feedback f WHERE i.id = :id";

    @Query(AVERAGE_SCORE_QUERY)
    double calculateAverageScore(@Param("id") long id );

    Optional<Interview> findByIdAndUserId(@Param("id") long id, @Param("userId") long userId);

    List<Interview> findByUserId(long id);
}