package com.grp1.locationAPI.controller;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.grp1.locationAPI.model.TransactionHistory;
import com.grp1.locationAPI.service.IProductService;
import com.grp1.locationAPI.service.ITransactionHistoryService;

@Controller
public class TransactionHistoryController {

    @Autowired
    private ITransactionHistoryService historyService;

    @Autowired
    private IProductService productService;

    @GetMapping("/transaction-history")
    public String historyPage(Model model) {
        List<TransactionHistory> hist = java.util.Collections.emptyList();
        try {
            hist = historyService.findAll();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            List<Map<String,Object>> dto = hist.stream().map(h -> {
                Map<String,Object> m = new HashMap<>();
                m.put("id", h.getId());
                m.put("type", h.getActionType());
                m.put("referenceId", h.getReferenceId());
                m.put("productId", h.getProductId());
                m.put("quantity", h.getQuantity());
                m.put("price", h.getPrice());
                m.put("discount", h.getDiscount());
                m.put("discountedPrice", h.getDiscountedPrice());
                m.put("brand", h.getBrand());
                m.put("itemType", h.getItemType());
                m.put("branch", h.getBranch());
                m.put("totalPrice", h.getTotalPrice());
                m.put("note", h.getNote());
                m.put("timestampFormatted", h.getTimestamp() == null ? "" : h.getTimestamp().format(fmt));
                return m;
            }).collect(Collectors.toList());
            model.addAttribute("history", dto);
        } catch (Exception e) {
            model.addAttribute("history", java.util.Collections.emptyList());
        }
        // also provide products so templates can resolve product names if desired
        try {
            List<com.grp1.locationAPI.model.Product> products = productService.findAll();
            model.addAttribute("products", products);
            // filters
            java.util.Set<String> types = new java.util.TreeSet<>();
            java.util.Set<String> brands = new java.util.TreeSet<>();
            java.util.Set<String> branches = new java.util.TreeSet<>();
            for (com.grp1.locationAPI.model.Product p : products) {
                if (p.getItemType() != null) types.add(p.getItemType());
                if (p.getCompany() != null) brands.add(p.getCompany());
                if (p.getBranch() != null) branches.add(p.getBranch());
            }
            model.addAttribute("types", types);
            model.addAttribute("brands", brands);
            model.addAttribute("branches", branches);
        } catch (Exception e) {
            model.addAttribute("products", java.util.Collections.emptyList());
        }
        // compute top 5 sold and top 5 ordered products from history
        try {
            ObjectMapper mapper = new ObjectMapper();
            Map<Long, Integer> soldTotals = hist.stream()
                    .filter(h -> "SALE".equalsIgnoreCase(h.getActionType()))
                    .filter(h -> h.getProductId() != null && h.getQuantity() != null)
                    .collect(Collectors.groupingBy(TransactionHistory::getProductId, Collectors.summingInt(TransactionHistory::getQuantity)));

            Map<Long, Integer> orderTotals = hist.stream()
                    .filter(h -> "ORDER".equalsIgnoreCase(h.getActionType()))
                    .filter(h -> h.getProductId() != null && h.getQuantity() != null)
                    .collect(Collectors.groupingBy(TransactionHistory::getProductId, Collectors.summingInt(TransactionHistory::getQuantity)));

            // helper map id -> name
            Map<Long, String> nameMap = new HashMap<>();
            for (com.grp1.locationAPI.model.Product p : productService.findAll()) {
                if (p.getId() != null) nameMap.put(p.getId(), p.getName());
            }

            List<Map<String,Object>> topSold = soldTotals.entrySet().stream()
                    .sorted((a,b) -> Integer.compare(b.getValue(), a.getValue()))
                    .limit(5)
                    .map(e -> {
                        Map<String,Object> m = new HashMap<>();
                        m.put("productId", e.getKey());
                        m.put("name", nameMap.getOrDefault(e.getKey(), "(product:"+e.getKey()+")"));
                        m.put("quantity", e.getValue());
                        return m;
                    }).collect(Collectors.toList());

            List<Map<String,Object>> topOrdered = orderTotals.entrySet().stream()
                    .sorted((a,b) -> Integer.compare(b.getValue(), a.getValue()))
                    .limit(5)
                    .map(e -> {
                        Map<String,Object> m = new HashMap<>();
                        m.put("productId", e.getKey());
                        m.put("name", nameMap.getOrDefault(e.getKey(), "(product:"+e.getKey()+")"));
                        m.put("quantity", e.getValue());
                        return m;
                    }).collect(Collectors.toList());

            model.addAttribute("topSoldJson", mapper.writeValueAsString(topSold));
            model.addAttribute("topOrderedJson", mapper.writeValueAsString(topOrdered));
        } catch (Exception ex) {
            model.addAttribute("topSoldJson", "[]");
            model.addAttribute("topOrderedJson", "[]");
        }
        return "transaction_history";
    }
}