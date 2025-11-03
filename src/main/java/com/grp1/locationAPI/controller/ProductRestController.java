package com.grp1.locationAPI.controller;

import com.grp1.locationAPI.model.Product;
import com.grp1.locationAPI.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
public class ProductRestController {
    @Autowired
    private IProductService productService;

    @GetMapping
    public List<Product> all() { return productService.findAll(); }

    @GetMapping("/{id}")
    public Optional<Product> get(@PathVariable Long id) { return productService.findById(id); }

    @PostMapping
    public Product create(@RequestBody Product p) { return productService.save(p); }

    @PutMapping("/{id}")
    public Product update(@PathVariable Long id, @RequestBody Product p) {
        p.setId(id);
        return productService.save(p);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { productService.deleteById(id); }

    @PostMapping("/{id}/adjust")
    public Product adjust(@PathVariable Long id, @RequestParam int delta) {
        return productService.adjustQuantity(id, delta);
    }
}
