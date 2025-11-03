package com.grp1.locationAPI.service;

import java.math.BigDecimal;
import java.util.List;

import com.grp1.locationAPI.model.TransactionHistory;

public interface ITransactionHistoryService {
    // Added 'branch' parameter so history entries can record product/branch origin
    void recordSale(Long saleId, Long productId, Integer qty, BigDecimal price, BigDecimal discount, BigDecimal discountedPrice, String brand, String itemType, String branch, BigDecimal totalPrice);
    void recordOrder(Long orderId, Long productId, Integer qty, BigDecimal price, BigDecimal discount, BigDecimal discountedPrice, String brand, String itemType, String branch, BigDecimal totalPrice, String note);
    List<TransactionHistory> findAll();
}