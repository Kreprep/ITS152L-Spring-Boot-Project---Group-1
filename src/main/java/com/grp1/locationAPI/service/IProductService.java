package com.grp1.locationAPI.service;

import com.grp1.locationAPI.model.Product;

import java.util.List;
import java.util.Optional;

public interface IProductService {
    List<Product> findAll();
    Optional<Product> findById(Long id);
    Product save(Product product);
    void deleteById(Long id);
    Product adjustQuantity(Long id, int delta);
}
