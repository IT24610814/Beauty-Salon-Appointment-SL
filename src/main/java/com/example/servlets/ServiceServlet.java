package com.example.servlets;

import com.example.handlers.ServiceHandler;
import com.example.models.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/service")
public class ServiceServlet extends HttpServlet {
    private ServiceHandler serviceHandler;

    @Override
    public void init() throws ServletException {
        serviceHandler = new ServiceHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            request.getRequestDispatcher("/service/add.jsp").forward(request, response);
        } else if ("list".equals(action)) {
            request.setAttribute("services", serviceHandler.getAllServices());
            request.getRequestDispatcher("/service/list.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            String id = request.getParameter("id");
            Service service = serviceHandler.getServiceById(id);
            if (service == null) {
                request.setAttribute("error", "Service not found with ID: " + id);
                request.setAttribute("services", serviceHandler.getAllServices());
                request.getRequestDispatcher("/service/list.jsp").forward(request, response);
            } else {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/service/edit.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            try {
                serviceHandler.deleteService(id);
                response.sendRedirect(request.getContextPath() + "/service?action=list");
            } catch (Exception e) {
                request.setAttribute("error", "Error deleting service: " + e.getMessage());
                request.setAttribute("services", serviceHandler.getAllServices());
                request.getRequestDispatcher("/service/list.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            try {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String duration = request.getParameter("duration");
                double price = Double.parseDouble(request.getParameter("price"));
                String description = request.getParameter("description");
                String type = request.getParameter("type");

                // Basic validation
                if (id == null || name == null || duration == null || type == null || id.isEmpty() || name.isEmpty() || duration.isEmpty() || type.isEmpty()) {
                    throw new IllegalArgumentException("All required fields must be filled.");
                }

                Service service = new Service(id, name, duration, price, description, type);
                serviceHandler.saveService(service);
                response.sendRedirect(request.getContextPath() + "/service?action=list");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price format: " + e.getMessage());
                request.getRequestDispatcher("/service/add.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/service/add.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Error adding service: " + e.getMessage());
                request.getRequestDispatcher("/service/add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            try {
                String originalId = request.getParameter("originalId");
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String duration = request.getParameter("duration");
                double price = Double.parseDouble(request.getParameter("price"));
                String description = request.getParameter("description");
                String type = request.getParameter("type");
                Service service = new Service(id, name, duration, price, description, type);
                serviceHandler.updateService(originalId, service);
                response.sendRedirect(request.getContextPath() + "/service?action=list");
            } catch (Exception e) {
                request.setAttribute("error", "Error updating service: " + e.getMessage());
                request.setAttribute("service", new Service(
                    request.getParameter("id"),
                    request.getParameter("name"),
                    request.getParameter("duration"),
                    Double.parseDouble(request.getParameter("price")),
                    request.getParameter("description"),
                    request.getParameter("type")
                ));
                request.getRequestDispatcher("/service/edit.jsp").forward(request, response);
            }
        }
    }
}