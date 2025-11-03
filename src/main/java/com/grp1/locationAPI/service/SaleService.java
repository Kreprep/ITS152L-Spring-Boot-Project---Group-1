// ...existing code...
package com.grp1.locationAPI.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grp1.locationAPI.model.Product;
import com.grp1.locationAPI.model.SaleTransaction;
import com.grp1.locationAPI.repository.ProductRepository;
import com.grp1.locationAPI.repository.SaleTransactionRepository;

@Service
public class SaleService implements ISaleService {
    @Autowired
    private SaleTransactionRepository txRepo;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private IProductService productService;

    @Autowired
    private ITransactionHistoryService historyService;

    @Override
    public SaleTransaction createTransaction(Long productId, int qty, BigDecimal discount, String brand, String itemType) {
        if (qty <= 0) throw new IllegalArgumentException("quantity must be > 0");
        Product p = productRepository.findById(productId).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        int current = p.getQuantity() == null ? 0 : p.getQuantity();
        if (current < qty) throw new IllegalArgumentException("Not enough stock");
        // determine prices
        BigDecimal unitPrice = p.getPrice() == null ? BigDecimal.ZERO : p.getPrice();
        BigDecimal d = (discount == null) ? BigDecimal.ZERO : discount;
        BigDecimal discounted = unitPrice.subtract(d);
        if (discounted.compareTo(BigDecimal.ZERO) < 0) discounted = BigDecimal.ZERO;
        BigDecimal total = discounted.multiply(new BigDecimal(qty));
        // deduct stock
        productService.adjustQuantity(productId, -qty);
        SaleTransaction tx = new SaleTransaction(p, qty, unitPrice, d, discounted, brand == null ? p.getCompany() : brand,
                itemType == null ? p.getItemType() : itemType, total, LocalDateTime.now());
        // ensure branch on tx is product branch
        tx.setBranch(p.getBranch());
        SaleTransaction saved = txRepo.save(tx);
        // record in transaction history (do not fail sale if history fails)
        try {
            historyService.recordSale(saved.getId(), p.getId(), qty, unitPrice, d, discounted, saved.getBrand(), saved.getItemType(), saved.getBranch(), total);
        } catch (Exception ex) {
            // ignore history errors - do not rollback the sale
        }
        return saved;
    }

    @Override
    public List<SaleTransaction> findAll() {
        return StreamSupport.stream(txRepo.findAll().spliterator(), false).collect(Collectors.toList());
    }
}