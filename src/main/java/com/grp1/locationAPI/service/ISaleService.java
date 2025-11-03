package com.grp1.locationAPI.service;

import java.math.BigDecimal;
import java.util.List;

import com.grp1.locationAPI.model.SaleTransaction;

public interface ISaleService {
    // discount is absolute amount subtracted from unit price (nullable -> zero)
    SaleTransaction createTransaction(Long productId, int qty, BigDecimal discount, String brand, String itemType);
    List<SaleTransaction> findAll();
}