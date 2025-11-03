package com.grp1.locationAPI.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.grp1.locationAPI.model.SaleTransaction;

@Repository
public interface SaleTransactionRepository extends CrudRepository<SaleTransaction, Long> {
}
