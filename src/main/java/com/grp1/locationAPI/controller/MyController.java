package com.grp1.locationAPI.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grp1.locationAPI.model.Country;
import com.grp1.locationAPI.service.ICountryService;

@Controller
public class MyController {
    @Autowired
    private ICountryService countryService;

    @GetMapping("/countries")
    public String findCountries(Model model){
        var countries= (List<Country>) countryService.findAll();
        model.addAttribute("countries",countries);
        return "showCountries";
    }
}
