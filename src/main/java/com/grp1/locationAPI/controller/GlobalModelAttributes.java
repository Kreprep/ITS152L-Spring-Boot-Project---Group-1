package com.grp1.locationAPI.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;

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

    @ModelAttribute("currentUserName")
    public String currentUserName(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object username = session.getAttribute("AUTH_USERNAME");
        return username == null ? null : username.toString();
    }

    @ModelAttribute("currentUserRole")
    public String currentUserRole(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object role = session.getAttribute("AUTH_ROLE");
        return role == null ? null : role.toString();
    }
}
