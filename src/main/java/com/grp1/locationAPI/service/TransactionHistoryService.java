package com.grp1.locationAPI.service;

import com.grp1.locationAPI.model.TransactionHistory;
import com.grp1.locationAPI.repository.TransactionHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class TransactionHistoryService implements ITransactionHistoryService {

    @Autowired
    private TransactionHistoryRepository repo;

    @Override
    @Transactional
    public void recordSale(Long saleId, Long productId, Integer qty, BigDecimal price, BigDecimal discount, BigDecimal discountedPrice, String brand, String itemType, String branch, BigDecimal totalPrice) {
        TransactionHistory h = new TransactionHistory();
        h.setActionType("SALE");
        h.setReferenceId(saleId);
        h.setProductId(productId);
        h.setQuantity(qty);
        h.setPrice(price);
        h.setDiscount(discount);
        h.setDiscountedPrice(discountedPrice);
        h.setBrand(brand);
        h.setItemType(itemType);
        h.setBranch(branch);
        h.setTotalPrice(totalPrice);
        h.setTimestamp(LocalDateTime.now());
        h.setNote("Sale recorded");
        repo.save(h);
    }

    @Override
    @Transactional
    public void recordOrder(Long orderId, Long productId, Integer qty, BigDecimal price, BigDecimal discount, BigDecimal discountedPrice, String brand, String itemType, String branch, BigDecimal totalPrice, String note) {
        TransactionHistory h = new TransactionHistory();
        h.setActionType("ORDER");
        h.setReferenceId(orderId);
        h.setProductId(productId);
        h.setQuantity(qty);
        h.setPrice(price);
        h.setDiscount(discount);
        h.setDiscountedPrice(discountedPrice);
        h.setBrand(brand);
        h.setItemType(itemType);
        h.setBranch(branch);
        h.setTotalPrice(totalPrice);
        h.setTimestamp(LocalDateTime.now());
        h.setNote(note);
        repo.save(h);
    }

    @Override
    public List<TransactionHistory> findAll() {
        List<TransactionHistory> out = new ArrayList<>();
        repo.findAll().forEach(out::add);
        return out;
    }
}