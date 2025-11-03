package com.grp1.locationAPI.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DbHealthController {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/health/db")
    public Map<String, Object> dbHealth() {
        Map<String, Object> r = new HashMap<>();
        try {
            Integer cnt = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'products'",
                    Integer.class);
            r.put("products_table_exists", cnt != null && cnt > 0);
        } catch (Exception e) {
            r.put("error", e.getMessage());
            r.put("products_table_exists", false);
        }
        return r;
    }
}
