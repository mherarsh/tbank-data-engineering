package ru.hse.db_connector.controller;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@RestController
@AllArgsConstructor
public class StudentController {

    @Autowired
    public NamedParameterJdbcTemplate myNamedParameterJdbcTemplate;

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @GetMapping("/count")
    public Integer getStudentsCount() {
        String key = "student_count";
        String cached = redisTemplate.opsForValue().get(key);

        if (cached != null) {
            System.out.println("!!!Returning cached value!!!");
            return Integer.valueOf(cached);
        }

        var sqlQuery = "select count(*) from students";
        var parameters = new MapSqlParameterSource();
        Integer count = myNamedParameterJdbcTemplate.queryForObject(sqlQuery, parameters, Integer.class);

        redisTemplate.opsForValue().set(key, String.valueOf(count), Duration.ofMinutes(5));
        System.out.println("!!!Returning currently counted value!!!");
        return count;
    }

    @PostMapping("/add")
    public int addStudent(@RequestParam("fullName") String fullName, @RequestParam("enrollmentYear") Integer enrollmentYear) {
        var sqlQuery = "insert into students (full_name, enrollment_year) values (:full_name, :enrollment_year)";
        var parameters = new MapSqlParameterSource();
        parameters.addValue("full_name", fullName);
        parameters.addValue("enrollment_year", enrollmentYear);
        return myNamedParameterJdbcTemplate.update(sqlQuery, parameters);
    }
}
