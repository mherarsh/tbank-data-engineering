package ru.hse.db_connector.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Duration;
import java.time.temporal.ChronoUnit;

@RestController
public class UserController {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @PostMapping("/auth/user/{id}")
    public String getUser(@PathVariable("id") String id) {
        String key = "session:" + id;

        redisTemplate.opsForValue().set(key, "logged_id", Duration.of(1, ChronoUnit.MINUTES)); // Через одну минуту ключ исчезнет
        return "logged_id";
    }

    @GetMapping("/auth/user/{id}")
    public String postUser(@PathVariable("id") String id) {
        if(redisTemplate.hasKey("session:" + id)) {
            return "User " + id + " is authorized";
        } else {
            return "User " + id + " is not authorized";
        }
    }

}
