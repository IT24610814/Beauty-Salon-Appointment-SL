package com.example.servlets;

import com.example.handlers.AdminHandler;
import com.example.models.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
    private AdminHandler adminHandler;

    @Override
    public void init() throws ServletException {
        adminHandler = new AdminHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
            return;
        }

        boolean isValid = false;
        for (Admin admin : adminHandler.getAdmins()) {
            if (admin.getUsername().equals(username) && admin.getPassword().equals(password)) {
                isValid = true;
                break;
            }
        }

        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInAdmin", username);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
        }
    }
}