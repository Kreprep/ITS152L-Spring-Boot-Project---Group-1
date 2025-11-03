package com.grp1.locationAPI.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.grp1.locationAPI.model.Product;
import com.grp1.locationAPI.model.PurchaseOrder;
import com.grp1.locationAPI.repository.PurchaseOrderRepository;

@Service
public class PurchaseOrderService implements IPurchaseOrderService {

    @Autowired
    private PurchaseOrderRepository purchaseOrderRepository;

    @Autowired
    private IProductService productService;

    @Autowired
    private ITransactionHistoryService historyService;

    @Override
    @Transactional
    public PurchaseOrder createOrder(Long productId, Integer quantity, String supplier, java.math.BigDecimal price, java.math.BigDecimal discount, String brand, String itemType) throws Exception {
        Optional<Product> pOpt = productService.findById(productId);
        if (pOpt.isEmpty()) {
            throw new Exception("Product not found");
        }
        Product p = pOpt.get();
        PurchaseOrder po = new PurchaseOrder();
        po.setProduct(p);
        po.setQuantity(quantity);
        po.setPrice(price);
        po.setDiscount(discount);
        java.math.BigDecimal d = (discount == null) ? java.math.BigDecimal.ZERO : discount;
        java.math.BigDecimal unit = (price == null) ? java.math.BigDecimal.ZERO : price;
        java.math.BigDecimal discounted = unit.subtract(d);
        if (discounted.compareTo(java.math.BigDecimal.ZERO) < 0) discounted = java.math.BigDecimal.ZERO;
        po.setDiscountedPrice(discounted);
        po.setBrand(brand == null ? p.getCompany() : brand);
        po.setBranch(p.getBranch());
        po.setItemType(itemType == null ? p.getItemType() : itemType);
        po.setSupplier(supplier);
        po.setStatus(PurchaseOrder.Status.PENDING);
        po.setOrderDate(LocalDateTime.now());
        PurchaseOrder saved = purchaseOrderRepository.save(po);
        // record creation in history
        try {
            java.math.BigDecimal total = null;
            if (unit != null) {
                total = discounted.multiply(new java.math.BigDecimal(saved.getQuantity()));
            }
            historyService.recordOrder(saved.getId(), saved.getProduct().getId(), saved.getQuantity(), unit, d, discounted, saved.getBrand(), saved.getItemType(), saved.getBranch(), total, "Order created");
        } catch (Exception ex) {
            // ignore
        }
        return saved;
    }

    @Override
    public List<PurchaseOrder> findAll() {
        List<PurchaseOrder> out = new ArrayList<>();
        purchaseOrderRepository.findAll().forEach(out::add);
        return out;
    }

    @Override
    @Transactional
    public void receiveOrder(Long orderId) throws Exception {
        Optional<PurchaseOrder> o = purchaseOrderRepository.findById(orderId);
        if (o.isEmpty()) throw new Exception("Order not found");
        PurchaseOrder po = o.get();
        if (po.getStatus() == PurchaseOrder.Status.RECEIVED) {
            throw new Exception("Order already received");
        }
        // Increase product quantity by order quantity
        productService.adjustQuantity(po.getProduct().getId(), po.getQuantity());
        po.setStatus(PurchaseOrder.Status.RECEIVED);
        po.setReceivedDate(LocalDateTime.now());
        PurchaseOrder saved = purchaseOrderRepository.save(po);
        try {
            java.math.BigDecimal total = null;
            if (saved.getDiscountedPrice() != null) {
                total = saved.getDiscountedPrice().multiply(new java.math.BigDecimal(saved.getQuantity()));
            }
            historyService.recordOrder(saved.getId(), saved.getProduct().getId(), saved.getQuantity(), saved.getPrice(), saved.getDiscount(), saved.getDiscountedPrice(), saved.getBrand(), saved.getItemType(), saved.getBranch(), total, "Order received");
        } catch (Exception ex) {
            // ignore
        }
    }
}