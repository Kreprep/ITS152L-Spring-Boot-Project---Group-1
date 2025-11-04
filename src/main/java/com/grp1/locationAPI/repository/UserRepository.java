package com.grp1.locationAPI.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.grp1.locationAPI.model.UserAccount;

public interface UserRepository extends CrudRepository<UserAccount, Long> {
    Optional<UserAccount> findByUsername(String username);
}
