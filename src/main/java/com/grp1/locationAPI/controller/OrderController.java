package com.grp1.locationAPI.controller;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grp1.locationAPI.model.PurchaseOrder;
import com.grp1.locationAPI.service.IProductService;
import com.grp1.locationAPI.service.IPurchaseOrderService;

@Controller
public class OrderController {

    @Autowired
    private IProductService productService;

    @Autowired
    private IPurchaseOrderService purchaseOrderService;

    @GetMapping({"/orders","/orders/list"})
    public String ordersPage(Model model){
        model.addAttribute("products", productService.findAll());
        try {
            List<PurchaseOrder> orders = purchaseOrderService.findAll();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            List<Map<String,Object>> dto = orders.stream().map(o -> {
                Map<String,Object> m = new HashMap<>();
                m.put("id", o.getId());
                m.put("product", o.getProduct());
                m.put("quantity", o.getQuantity());
                m.put("supplier", o.getSupplier());
                m.put("status", o.getStatus() == null ? "" : o.getStatus().name());
                m.put("orderDateFormatted", o.getOrderDate() == null ? "" : o.getOrderDate().format(fmt));
                m.put("receivedDateFormatted", o.getReceivedDate() == null ? "" : o.getReceivedDate().format(fmt));
                m.put("priceFormatted", o.getPrice() == null ? "" : ("$" + o.getPrice().setScale(2, java.math.RoundingMode.HALF_UP).toString()));
                return m;
            }).collect(Collectors.toList());
            model.addAttribute("orders", dto);
        } catch (Exception e) {
            model.addAttribute("orders", java.util.Collections.emptyList());
        }
        return "orders";
    }

    @PostMapping("/orders/create")
    public String createOrder(@RequestParam Long productId,
                              @RequestParam Integer quantity,
                              @RequestParam String supplier,
                              @RequestParam(required = false) String price,
                              @RequestParam(required = false) String discount,
                              @RequestParam(required = false) String brand,
                              @RequestParam(required = false) String itemType,
                              Model model){
        try{
            BigDecimal p = null;
            BigDecimal d = null;
            if (price != null && !price.isBlank()) {
                p = new BigDecimal(price.trim());
            }
            if (discount != null && !discount.isBlank()) {
                d = new BigDecimal(discount.trim());
            }
            purchaseOrderService.createOrder(productId, quantity, supplier, p, d, brand, itemType);
            model.addAttribute("message", "Order created");
        }catch(Exception e){
            model.addAttribute("error", e.getMessage());
        }
        model.addAttribute("products", productService.findAll());
        return "orders";
    }

    @PostMapping("/orders/receive")
    public String receiveOrder(@RequestParam Long id, Model model){
        try{
            purchaseOrderService.receiveOrder(id);
            model.addAttribute("message", "Order marked as received and stock updated");
        }catch(Exception e){
            model.addAttribute("error", e.getMessage());
        }
        model.addAttribute("products", productService.findAll());
        try {
            List<PurchaseOrder> orders = purchaseOrderService.findAll();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            List<Map<String,Object>> dto = orders.stream().map(o -> {
                Map<String,Object> m = new HashMap<>();
                m.put("id", o.getId());
                m.put("product", o.getProduct());
                m.put("quantity", o.getQuantity());
                m.put("supplier", o.getSupplier());
                m.put("status", o.getStatus() == null ? "" : o.getStatus().name());
                m.put("orderDateFormatted", o.getOrderDate() == null ? "" : o.getOrderDate().format(fmt));
                m.put("receivedDateFormatted", o.getReceivedDate() == null ? "" : o.getReceivedDate().format(fmt));
                m.put("priceFormatted", o.getPrice() == null ? "" : ("$" + o.getPrice().setScale(2, java.math.RoundingMode.HALF_UP).toString()));
                return m;
            }).collect(Collectors.toList());
            model.addAttribute("orders", dto);
        } catch (Exception e) {
            model.addAttribute("orders", java.util.Collections.emptyList());
        }
        return "orders";
    }
}
