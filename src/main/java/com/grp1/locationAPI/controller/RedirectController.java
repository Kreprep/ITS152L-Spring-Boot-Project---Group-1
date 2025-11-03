package com.grp1.locationAPI.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RedirectController {
    // Friendly redirect for legacy/singular URL
    @GetMapping("/manage-product")
    public String redirectManageProduct(){
        return "redirect:/manage-products";
    }

    @GetMapping("/sale")
    public String redirectSale(){
        return "redirect:/sales";
    }
}
