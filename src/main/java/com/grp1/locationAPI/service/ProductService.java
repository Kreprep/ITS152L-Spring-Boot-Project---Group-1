package com.grp1.locationAPI.service;

import com.grp1.locationAPI.model.Product;
import com.grp1.locationAPI.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductService implements IProductService {
    @Autowired
    private ProductRepository repository;

    @Override
    public List<Product> findAll() {
        return (List<Product>) repository.findAll();
    }

    @Override
    public Optional<Product> findById(Long id) {
        return repository.findById(id);
    }

    @Override
    public Product save(Product product) {
        if (product.getQuantity() == null) product.setQuantity(0);
        return repository.save(product);
    }

    @Override
    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    @Override
    public Product adjustQuantity(Long id, int delta) {
        Product p = repository.findById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        int newQty = (p.getQuantity() == null ? 0 : p.getQuantity()) + delta;
        if (newQty < 0) newQty = 0;
        p.setQuantity(newQty);
        return repository.save(p);
    }
}
