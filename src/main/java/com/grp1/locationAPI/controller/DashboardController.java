package com.grp1.locationAPI.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grp1.locationAPI.service.IProductService;
import com.grp1.locationAPI.service.ISaleService;
import com.grp1.locationAPI.service.ICountryService;
import java.util.List;
import com.grp1.locationAPI.model.Product;

@Controller
public class DashboardController {
    @Autowired
    private IProductService productService;

    @Autowired
    private ICountryService countryService;

    @Autowired
    private ISaleService saleService;

    @GetMapping({"/","/dashboard"})
    public String dashboard(Model model){
        List<Product> products = productService.findAll();
        model.addAttribute("productCount", products == null ? 0 : products.size());
        // keep countries disabled if table isn't present
        try {
            model.addAttribute("countryCount", countryService.findAll().size());
        } catch (Exception e) {
            model.addAttribute("countryCount", 0);
        }
        model.addAttribute("recentProducts", products == null ? java.util.Collections.emptyList() : products.stream().limit(6).toList());
        try {
            model.addAttribute("recentTransactions", saleService.findAll().stream().limit(6).toList());
        } catch (Exception e) {
            // If the sale_transactions table doesn't exist or another DB error occurs,
            // avoid throwing a 500 and show an empty transactions list on the dashboard.
            model.addAttribute("recentTransactions", java.util.Collections.emptyList());
        }
        return "dashboard";
    }
}
