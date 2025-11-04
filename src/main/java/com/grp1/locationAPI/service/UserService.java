package com.grp1.locationAPI.service;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.grp1.locationAPI.model.UserAccount;
import com.grp1.locationAPI.repository.UserRepository;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Service
public class UserService implements IUserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<UserAccount> findByUsername(String username) {
        if (username == null) {
            return Optional.empty();
        }
        return userRepository.findByUsername(username.trim());
    }

    @Override
    @Transactional
    public UserAccount createUser(String username, String password, UserAccount.Role role) throws Exception {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (role == null) {
            throw new IllegalArgumentException("Role is required");
        }
        String normalized = username.trim();
        if (userRepository.findByUsername(normalized).isPresent()) {
            throw new Exception("Username already exists");
        }
        UserAccount user = new UserAccount();
        user.setUsername(normalized);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole(role);
        return userRepository.save(user);
    }

    @Override
    public boolean verifyPassword(UserAccount user, String rawPassword) {
        if (user == null || rawPassword == null) {
            return false;
        }
        return passwordEncoder.matches(rawPassword, user.getPasswordHash());
    }

    @Override
    public long count() {
        return userRepository.count();
    }
}
