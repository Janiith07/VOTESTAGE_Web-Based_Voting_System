package com.voting.service;

import com.voting.dao.PersonDAO;
import com.voting.model.Person;

import java.sql.SQLException;

public class PersonService {

    // You can add common methods here if needed
    public static Person getPersonById(String id) throws SQLException {
        return PersonDAO.getPersonById(id);
    }
}