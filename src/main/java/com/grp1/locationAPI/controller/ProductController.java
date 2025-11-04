package com.grp1.locationAPI.controller;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grp1.locationAPI.model.Product;
import com.grp1.locationAPI.model.SaleTransaction;
import com.grp1.locationAPI.service.IProductService;
import com.grp1.locationAPI.service.ISaleService;

@Controller
public class ProductController {
    @Autowired
    private IProductService productService;
    @Autowired
    private ISaleService saleService;

    @Value("${app.inventory.alert-threshold:5}")
    private int lowStockThreshold;
    // ...existing code...

    @PostMapping("/add-product")
    public String addOrUpdateProduct(@RequestParam(required = false) Long id,
                                     @RequestParam String name,
                                     @RequestParam(required = false) String description,
                                     @RequestParam(required = false) Integer quantity,
                                     @RequestParam(required = false) String price,
                                     @RequestParam(required = false) String itemType,
                                     @RequestParam(required = false) String company,
                                     @RequestParam(required = false) String branch,
                                     Model model) {
        try{
            Product p = new Product();
            if (id != null) p.setId(id);
            p.setName(name);
            p.setDescription(description);
            p.setQuantity(quantity == null ? 0 : quantity);
            if (price != null && !price.isBlank()) {
                p.setPrice(new BigDecimal(price.trim()));
            }
            // new fields
            p.setItemType(itemType);
            p.setCompany(company);
            p.setBranch(branch);
            productService.save(p);
            model.addAttribute("message", "Product saved");
        }catch(Exception e){
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    @GetMapping("/manage-products")
    public String manageProducts(Model model) {
        populateProducts(model);
        return "manageProducts";
    }

    @GetMapping("/sales")
    public String salesPage(Model model) {
        // reuse populateProducts which adds products and recent sales DTO
        populateProducts(model);
        return "sales";
    }

    @PostMapping("/sales/create")
    public String createSale(@RequestParam Long productId,
                             @RequestParam int quantity,
                             @RequestParam(required = false) String discount,
                             @RequestParam(required = false) String brand,
                             @RequestParam(required = false) String branch,
                             Model model) {
        try {
            java.math.BigDecimal d = null;
            if (discount != null && !discount.isBlank()) {
                d = new java.math.BigDecimal(discount.trim());
            }
            // saleService will take branch from product; brand overrides if provided
            saleService.createTransaction(productId, quantity, d, brand, null);
            model.addAttribute("message", "Sale created");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "sales";
    }

    @PostMapping("/products/add-quantity")
    public String addQuantity(@RequestParam Long id, Model model) {
        try {
            productService.adjustQuantity(id, 1);
            model.addAttribute("message", "Quantity increased");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    @PostMapping("/products/subtract-quantity")
    public String subtractQuantity(@RequestParam Long id, Model model) {
        try {
            productService.adjustQuantity(id, -1);
            model.addAttribute("message", "Quantity decreased");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    @PostMapping("/products/delete")
    public String deleteProduct(@RequestParam Long id, Model model) {
        try {
            productService.deleteById(id);
            model.addAttribute("message", "Product deleted");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    // --- Compatibility endpoints for older templates that post to legacy paths ---
    @PostMapping("/adjust-stock")
    public String adjustStock(@RequestParam Long id,
                              @RequestParam(required = false, defaultValue = "1") Integer delta,
                              Model model) {
        try {
            productService.adjustQuantity(id, delta == null ? 1 : delta);
            model.addAttribute("message", "Stock updated");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    @PostMapping("/delete-product")
    public String deleteProductLegacy(@RequestParam Long id, Model model) {
        try {
            productService.deleteById(id);
            model.addAttribute("message", "Product deleted");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        populateProducts(model);
        return "manageProducts";
    }

    @GetMapping("/edit-product/{id}")
    public String editProduct(@PathVariable Long id, Model model) {
        try {
            Optional<Product> p = productService.findById(id);
            model.addAttribute("product", p.orElse(new Product()));
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("product", new Product());
        }
        // ensure filters / lists are available if addProduct template expects them
        populateProducts(model);
        return "addProduct";
    }

    

    private void populateProducts(Model model){
        List<Product> productList = productService.findAll();
        model.addAttribute("products", productList);
    List<Product> lowStockProducts;
    try {
        lowStockProducts = productService.findLowStock(lowStockThreshold);
    } catch (Exception ex) {
        lowStockProducts = java.util.Collections.emptyList();
    }
    model.addAttribute("lowStockProducts", lowStockProducts);
    model.addAttribute("lowStockPreview", lowStockProducts.stream().limit(5).collect(Collectors.toList()));
    model.addAttribute("lowStockThreshold", lowStockThreshold);
    model.addAttribute("lowStockCount", lowStockProducts.size());
    model.addAttribute("lowStockExtraCount", Math.max(0, lowStockProducts.size() - 5));
    long outOfStockCount = lowStockProducts.stream()
        .filter(p -> (p.getQuantity() == null ? 0 : p.getQuantity()) == 0)
        .count();
    model.addAttribute("outOfStockCount", outOfStockCount);
    model.addAttribute("hasLowStock", !lowStockProducts.isEmpty());
        // populate filter options
        java.util.Set<String> types = new java.util.TreeSet<>();
        java.util.Set<String> brands = new java.util.TreeSet<>();
        java.util.Set<String> branches = new java.util.TreeSet<>();
        for (Product p : productList) {
            if (p.getItemType() != null) types.add(p.getItemType());
            if (p.getCompany() != null) brands.add(p.getCompany());
            if (p.getBranch() != null) branches.add(p.getBranch());
        }
        model.addAttribute("types", types);
        model.addAttribute("brands", brands);
        model.addAttribute("branches", branches);
        try {
            List<SaleTransaction> sales = saleService.findAll();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            List<Map<String,Object>> dto = sales.stream().map(t -> {
                Map<String,Object> m = new HashMap<>();
                m.put("id", t.getId());
                m.put("product", t.getProduct());
                m.put("quantity", t.getQuantity());
                m.put("totalPrice", t.getTotalPrice());
                m.put("timestampFormatted", t.getTimestamp() == null ? "" : t.getTimestamp().format(fmt));
                return m;
            }).collect(Collectors.toList());
            model.addAttribute("sales", dto);
        } catch (Exception e) {
            model.addAttribute("sales", java.util.Collections.emptyList());
        }
    }
}