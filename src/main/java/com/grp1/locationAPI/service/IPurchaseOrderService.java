package com.grp1.locationAPI.service;

import java.math.BigDecimal;
import java.util.List;

import com.grp1.locationAPI.model.PurchaseOrder;

public interface IPurchaseOrderService {
    PurchaseOrder createOrder(Long productId, Integer quantity, String supplier, BigDecimal price, BigDecimal discount, String brand, String itemType) throws Exception;
    List<PurchaseOrder> findAll();
    void receiveOrder(Long orderId) throws Exception;
}