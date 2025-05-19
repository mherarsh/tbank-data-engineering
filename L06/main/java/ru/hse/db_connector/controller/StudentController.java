package ru.hse.db_connector.controller;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@RestController
@AllArgsConstructor
public class StudentController {

    @Autowired
    public NamedParameterJdbcTemplate myNamedParameterJdbcTemplate;

    @GetMapping("/count")
    public Integer getStudentsCount() {
        var sqlQuery = "select count(*) from students";
        var parameters = new MapSqlParameterSource();
        return myNamedParameterJdbcTemplate.queryForObject(sqlQuery, parameters, Integer.class);
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
