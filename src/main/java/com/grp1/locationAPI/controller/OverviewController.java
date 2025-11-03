package com.grp1.locationAPI.controller;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grp1.locationAPI.model.PurchaseOrder;
import com.grp1.locationAPI.model.SaleTransaction;
import com.grp1.locationAPI.service.IPurchaseOrderService;
import com.grp1.locationAPI.service.ISaleService;

@Controller
public class OverviewController {

    @Autowired
    private ISaleService saleService;

    @Autowired
    private IPurchaseOrderService purchaseOrderService;

    @GetMapping("/overview")
    public String overview(Model model) {
        List<SaleTransaction> sales = saleService.findAll();
        List<PurchaseOrder> orders = purchaseOrderService.findAll();

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        Map<String, BigDecimal> salesByDay = new TreeMap<>();
        for (SaleTransaction s : sales) {
            if (s.getTimestamp() == null) continue;
            String key = s.getTimestamp().toLocalDate().format(fmt);
            BigDecimal v = s.getTotalPrice() == null ? BigDecimal.ZERO : s.getTotalPrice();
            salesByDay.put(key, salesByDay.getOrDefault(key, BigDecimal.ZERO).add(v));
        }

        Map<String, BigDecimal> ordersByDay = new TreeMap<>();
        for (PurchaseOrder o : orders) {
            if (o.getOrderDate() == null) continue;
            String key = o.getOrderDate().toLocalDate().format(fmt);
            BigDecimal unit = o.getPrice() == null ? BigDecimal.ZERO : o.getPrice();
            BigDecimal total = unit.multiply(new BigDecimal(o.getQuantity() == null ? 0 : o.getQuantity()));
            ordersByDay.put(key, ordersByDay.getOrDefault(key, BigDecimal.ZERO).add(total));
        }

        // union of dates
        Set<String> dateKeys = new TreeSet<>();
        dateKeys.addAll(salesByDay.keySet());
        dateKeys.addAll(ordersByDay.keySet());

        List<String> labels = new ArrayList<>(dateKeys);
        List<Double> salesData = labels.stream()
                .map(d -> salesByDay.getOrDefault(d, BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP).doubleValue())
                .collect(Collectors.toList());
        List<Double> ordersData = labels.stream()
                .map(d -> ordersByDay.getOrDefault(d, BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP).doubleValue())
                .collect(Collectors.toList());

        // averages
        BigDecimal totalSales = sales.stream().map(s -> s.getTotalPrice() == null ? BigDecimal.ZERO : s.getTotalPrice())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal avgSale = sales.isEmpty() ? BigDecimal.ZERO : totalSales.divide(new BigDecimal(sales.size()), 2, RoundingMode.HALF_UP);

        BigDecimal totalOrders = orders.stream().map(o -> {
            if (o.getPrice() == null) return BigDecimal.ZERO;
            return o.getPrice().multiply(new BigDecimal(o.getQuantity() == null ? 0 : o.getQuantity()));
        }).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal avgOrder = orders.isEmpty() ? BigDecimal.ZERO : totalOrders.divide(new BigDecimal(orders.size()), 2, RoundingMode.HALF_UP);

        model.addAttribute("labels", labels);
        model.addAttribute("salesData", salesData);
        model.addAttribute("ordersData", ordersData);
        model.addAttribute("avgSaleFormatted", "$" + avgSale.setScale(2, RoundingMode.HALF_UP).toString());
        model.addAttribute("avgOrderFormatted", "$" + avgOrder.setScale(2, RoundingMode.HALF_UP).toString());

    // top sold items by quantity
    Map<String, Integer> soldByProduct = new TreeMap<>();
    for (SaleTransaction s : sales) {
        String pname = (s.getProduct() == null || s.getProduct().getName() == null) ? "(unknown)" : s.getProduct().getName();
        Integer qty = s.getQuantity() == null ? 0 : s.getQuantity();
        soldByProduct.put(pname, soldByProduct.getOrDefault(pname, 0) + qty);
    }

    // top ordered items by quantity
    Map<String, Integer> orderedByProduct = new TreeMap<>();
    for (PurchaseOrder o : orders) {
        String pname = (o.getProduct() == null || o.getProduct().getName() == null) ? "(unknown)" : o.getProduct().getName();
        Integer qty = o.getQuantity() == null ? 0 : o.getQuantity();
        orderedByProduct.put(pname, orderedByProduct.getOrDefault(pname, 0) + qty);
    }

    // take top N (e.g., 5)
    int topN = 5;
    List<Map.Entry<String,Integer>> topSold = soldByProduct.entrySet().stream()
        .sorted((a,b) -> b.getValue().compareTo(a.getValue()))
        .limit(topN)
        .collect(Collectors.toList());
    List<Map.Entry<String,Integer>> topOrdered = orderedByProduct.entrySet().stream()
        .sorted((a,b) -> b.getValue().compareTo(a.getValue()))
        .limit(topN)
        .collect(Collectors.toList());

    List<String> topSoldLabels = topSold.stream().map(Map.Entry::getKey).collect(Collectors.toList());
    List<Integer> topSoldCounts = topSold.stream().map(Map.Entry::getValue).collect(Collectors.toList());
    List<String> topOrderedLabels = topOrdered.stream().map(Map.Entry::getKey).collect(Collectors.toList());
    List<Integer> topOrderedCounts = topOrdered.stream().map(Map.Entry::getValue).collect(Collectors.toList());

    model.addAttribute("topSoldLabels", topSoldLabels);
    model.addAttribute("topSoldCounts", topSoldCounts);
    model.addAttribute("topOrderedLabels", topOrderedLabels);
    model.addAttribute("topOrderedCounts", topOrderedCounts);

        return "overview";
    }
}
