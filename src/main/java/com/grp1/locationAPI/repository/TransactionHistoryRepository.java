package com.grp1.locationAPI.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.grp1.locationAPI.model.TransactionHistory;

@Repository
public interface TransactionHistoryRepository extends CrudRepository<TransactionHistory, Long> {
}
