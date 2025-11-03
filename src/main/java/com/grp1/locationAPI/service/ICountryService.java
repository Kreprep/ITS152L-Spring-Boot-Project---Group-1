package com.grp1.locationAPI.service;

import com.grp1.locationAPI.model.Country;

import java.util.List;

public interface ICountryService {
    List<Country> findAll();
    Country addCountry(Country country);
}
