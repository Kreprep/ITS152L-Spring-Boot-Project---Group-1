package com.grp1.locationAPI.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("AUTH_USERNAME") != null;
        if (isLoggedIn) {
            return true;
        }
        response.sendRedirect("/login");
        return false;
    }
}
