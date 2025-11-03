package com.grp1.locationAPI.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "sale_transactions")
public class SaleTransaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private Integer quantity;
    private BigDecimal price; // unit price at time of sale
    private BigDecimal discount; // absolute discount amount
    private BigDecimal discountedPrice; // unit price after discount
    private String brand;
    private String itemType;
    private String branch;
    private BigDecimal totalPrice;
    private LocalDateTime timestamp;

    public SaleTransaction() {}

    public SaleTransaction(Product product, Integer quantity, BigDecimal price, BigDecimal discount,
                           BigDecimal discountedPrice, String brand, String itemType, BigDecimal totalPrice, LocalDateTime timestamp) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
        this.discount = discount;
        this.discountedPrice = discountedPrice;
        this.brand = brand;
        this.itemType = itemType;
        this.branch = product == null ? null : product.getBranch();
        this.totalPrice = totalPrice;
        this.timestamp = timestamp;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getDiscount() { return discount; }
    public void setDiscount(BigDecimal discount) { this.discount = discount; }

    public BigDecimal getDiscountedPrice() { return discountedPrice; }
    public void setDiscountedPrice(BigDecimal discountedPrice) { this.discountedPrice = discountedPrice; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}