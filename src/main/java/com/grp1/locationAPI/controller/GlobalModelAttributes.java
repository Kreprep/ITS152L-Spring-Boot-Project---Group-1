package com.grp1.locationAPI.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributes {

    // intentionally keep DB info hidden from templates by returning empty strings
    @ModelAttribute("dbUser")
    public String dbUser() {
        return "";
    }

    @ModelAttribute("dbHost")
    public String dbHost() {
        return "";
    }
}
