package com.example.servlets;

import com.example.handlers.CustomerHandler;
import com.example.handlers.ServiceHandler;
import com.example.handlers.StylistHandler;
import com.example.models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {
    private CustomerHandler customerHandler;
    private ServiceHandler serviceHandler;
    private StylistHandler stylistHandler;

    @Override
    public void init() throws ServletException {
        this.customerHandler = new CustomerHandler(getServletContext());
        this.serviceHandler = new ServiceHandler(getServletContext());
        this.stylistHandler = new StylistHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            request.getRequestDispatcher("/customer/register.jsp").forward(request, response);
        } else if ("login".equals(action)) {
            request.getRequestDispatcher("/customer/login.jsp").forward(request, response);
        } else if ("list".equals(action)) {
            request.setAttribute("customers", customerHandler.getAllCustomers());
            request.getRequestDispatcher("/customer/customer-home.jsp").forward(request, response);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer customer = customerHandler.getCustomerById(id);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/customer/update.jsp").forward(request, response);
        } else if ("book".equals(action)) {
            request.setAttribute("services", serviceHandler.getAllServices());
            request.setAttribute("stylists", stylistHandler.getAllStylists());
            request.getRequestDispatcher("/bookAppointment.jsp").forward(request, response);
        } else if ("notifications".equals(action)) {
            request.getRequestDispatcher("/customer/notifications.jsp").forward(request, response);
        } else {
            request.setAttribute("customers", customerHandler.getAllCustomers());
            request.getRequestDispatcher("/customer/customer-home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String type = request.getParameter("type");
            Customer customer = new Customer(0, name, email, phone, type);
            customerHandler.saveCustomer(customer);
            response.sendRedirect("customer?action=list");
        } else if ("login".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String email = request.getParameter("email");
            Customer customer = customerHandler.getCustomerById(id);
            if (customer != null && customer.getEmail().equals(email)) {
                request.getSession().setAttribute("customer", customer);
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("customer?action=login&error=invalid");
            }
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String type = request.getParameter("type");
            Customer customer = new Customer(id, name, email, phone, type);
            customerHandler.updateCustomer(customer);
            response.sendRedirect("customer?action=list");
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                customerHandler.deleteCustomer(id);
                response.sendRedirect("customer?action=list");
            } catch (Exception e) {
                response.sendRedirect("customer?action=list&error=deleteFailed");
            }
        } else if ("book".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String serviceType = request.getParameter("serviceType");
            String type = "VIP Services".equals(serviceType) ? "VIP" : "Regular";
            Customer customer = new Customer(0, name, email, phone, type);
            customerHandler.saveCustomer(customer);
            response.sendRedirect(request.getContextPath() + "/mainIndex.jsp");
        }
    }
}