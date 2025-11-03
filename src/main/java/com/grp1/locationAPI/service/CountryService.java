package com.grp1.locationAPI.service;

import com.grp1.locationAPI.model.Country;
import com.grp1.locationAPI.repository.CountryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryService implements ICountryService {
    @Autowired
    private CountryRepository repository;

    @Override
    public List<Country> findAll() {
        return (List<Country>) repository.findAll();
    }

    @Override
    public Country addCountry(Country country) {
        return repository.save(country);
    }
}

