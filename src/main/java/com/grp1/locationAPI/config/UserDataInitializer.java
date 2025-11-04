package com.grp1.locationAPI.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.grp1.locationAPI.model.UserAccount;
import com.grp1.locationAPI.service.IUserService;

@Component
public class UserDataInitializer implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(UserDataInitializer.class);
    private final IUserService userService;

    public UserDataInitializer(IUserService userService) {
        this.userService = userService;
    }

    @Override
    public void run(String... args) {
        ensureUserExists("admin", "admin123", UserAccount.Role.ADMIN);
        ensureUserExists("employee", "employee123", UserAccount.Role.EMPLOYEE);
    }

    private void ensureUserExists(String username, String password, UserAccount.Role role) {
        if (userService.findByUsername(username).isPresent()) {
            return;
        }
        try {
            userService.createUser(username, password, role);
            log.info("Created default {} account", role.name().toLowerCase());
        } catch (Exception e) {
            log.warn("Unable to create default user {}: {}", username, e.getMessage());
        }
    }
}
