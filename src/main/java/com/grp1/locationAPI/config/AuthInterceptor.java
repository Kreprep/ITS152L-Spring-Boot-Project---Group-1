package com.grp1.locationAPI.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthInterceptor implements HandlerInterceptor {
    private static final String ROLE_EMPLOYEE = "EMPLOYEE";
    private static final String[] ADMIN_ONLY_PREFIXES = {
            "/manage-products",
            "/manage-product",
            "/add-product",
            "/addProduct",
            "/products",
            "/adjust-stock",
            "/delete-product",
            "/orders",
            "/api/products"
    };

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("AUTH_USERNAME") != null;
        if (isLoggedIn) {
            if (isEmployeeAttemptingAdminAction(request, session)) {
                response.sendRedirect("/access-denied");
                return false;
            }
            return true;
        }
        response.sendRedirect("/login");
        return false;
    }

    private boolean isEmployeeAttemptingAdminAction(HttpServletRequest request, HttpSession session) {
        Object roleObj = session.getAttribute("AUTH_ROLE");
        if (roleObj == null) {
            return false;
        }
        String role = roleObj.toString();
        if (!ROLE_EMPLOYEE.equals(role)) {
            return false;
        }
        String path = request.getRequestURI();
        if (path == null) {
            return false;
        }
        for (String prefix : ADMIN_ONLY_PREFIXES) {
            if (path.equals(prefix) || path.startsWith(prefix + "/")) {
                return true;
            }
        }
        return false;
    }
}
