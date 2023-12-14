package com.sundatabase.test;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewsController {
    @GetMapping("/login")
    public String login(Model model) {
        return "login";
    }

    @GetMapping("/createcustomer")
    public String createCustomer(Model model) {
        return "createcustomer";
    }

    @GetMapping("/customers")
    public String detailCustomer(Model model) {
        return "customers";
    }
}