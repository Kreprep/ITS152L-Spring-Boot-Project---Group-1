package com.grp1.locationAPI.controller;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grp1.locationAPI.model.UserAccount;
import com.grp1.locationAPI.service.IUserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {
    private final IUserService userService;

    public AuthController(IUserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        if (session != null && session.getAttribute("AUTH_USERNAME") != null) {
            return "redirect:/dashboard";
        }
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String username,
                              @RequestParam String password,
                              HttpServletRequest request,
                              Model model) {
        Optional<UserAccount> userOpt = userService.findByUsername(username);
        if (userOpt.isEmpty() || !userService.verifyPassword(userOpt.get(), password)) {
            model.addAttribute("error", "Invalid username or password");
            model.addAttribute("username", username);
            return "login";
        }
        UserAccount user = userOpt.get();
        HttpSession session = request.getSession(true);
        session.setAttribute("AUTH_USER_ID", user.getId());
        session.setAttribute("AUTH_USERNAME", user.getUsername());
        session.setAttribute("AUTH_ROLE", user.getRole().name());
        return "redirect:/dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login";
    }
}
