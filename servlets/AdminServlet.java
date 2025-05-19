package com.example.servlets;

import com.example.handlers.AdminHandler;
import com.example.models.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private AdminHandler adminHandler;

    @Override
    public void init() throws ServletException {
        adminHandler = new AdminHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                request.getRequestDispatcher("/admin/add.jsp").forward(request, response);
                break;
            case "edit":
                String idStr = request.getParameter("id");
                try {
                    int id = Integer.parseInt(idStr);
                    Admin admin = adminHandler.getAdminById(id);
                    if (admin != null) {
                        request.setAttribute("admin", admin);
                        request.getRequestDispatcher("/admin/edit.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Admin not found.");
                        request.setAttribute("admins", adminHandler.getAdmins());
                        request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid admin ID.");
                    request.setAttribute("admins", adminHandler.getAdmins());
                    request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
                }
                break;
            case "list":
            default:
                request.setAttribute("admins", adminHandler.getAdmins());
                request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            request.setAttribute("admins", adminHandler.getAdmins());
            request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "add":
                try {
                    int id = adminHandler.getAdmins().stream()
                            .mapToInt(Admin::getId)
                            .max()
                            .orElse(0) + 1;
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    Admin newAdmin = new Admin(id, name, email, phone, username, password);
                    adminHandler.addAdmin(newAdmin);
                    response.sendRedirect("admin?action=list");
                } catch (IOException e) {
                    request.setAttribute("error", "Failed to add admin: " + e.getMessage());
                    request.getRequestDispatcher("/admin/add.jsp").forward(request, response);
                }
                break;
            case "edit":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    Admin updatedAdmin = new Admin(id, name, email, phone, username, password);
                    adminHandler.updateAdmin(updatedAdmin);
                    response.sendRedirect("admin?action=list");
                } catch (NumberFormatException | IOException e) {
                    request.setAttribute("error", "Failed to update admin: " + e.getMessage());
                    Admin admin = adminHandler.getAdminById(Integer.parseInt(request.getParameter("id")));
                    request.setAttribute("admin", admin);
                    request.getRequestDispatcher("/admin/edit.jsp").forward(request, response);
                }
                break;
            case "delete":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    adminHandler.deleteAdmin(id);
                    response.sendRedirect("admin?action=list");
                } catch (NumberFormatException | IOException e) {
                    request.setAttribute("error", "Failed to delete admin: " + e.getMessage());
                    request.setAttribute("admins", adminHandler.getAdmins());
                    request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
                }
                break;
            default:
                request.setAttribute("error", "Invalid action.");
                request.setAttribute("admins", adminHandler.getAdmins());
                request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
                break;
        }
    }
}