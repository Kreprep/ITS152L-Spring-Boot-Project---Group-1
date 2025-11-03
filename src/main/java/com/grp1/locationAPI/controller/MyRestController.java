package com.grp1.locationAPI.controller;

import com.grp1.locationAPI.model.Country;
import com.grp1.locationAPI.service.ICountryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class MyRestController {
    @Autowired
    private ICountryService countryService;

    @RequestMapping("/all-users")
    public List<Country> getAllUser(){
        return countryService.findAll();
    }
}

