package com.grp1.locationAPI.service;

import java.util.Optional;

import com.grp1.locationAPI.model.UserAccount;

public interface IUserService {
    Optional<UserAccount> findByUsername(String username);
    UserAccount createUser(String username, String password, UserAccount.Role role) throws Exception;
    boolean verifyPassword(UserAccount user, String rawPassword);
    long count();
}
