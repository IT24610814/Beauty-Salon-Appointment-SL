package com.example.servlets;

import com.example.handlers.AppointmentHandler;
import com.example.handlers.CustomerHandler;
import com.example.models.Appointment;
import com.example.models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/appointment")
public class AppointmentServlet extends HttpServlet {
    private AppointmentHandler appointmentHandler;
    private CustomerHandler customerHandler;

    @Override
    public void init() throws ServletException {
        this.appointmentHandler = new AppointmentHandler();
        this.customerHandler = new CustomerHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("book".equals(action)) {
            request.getRequestDispatcher("/appointment/book.jsp").forward(request, response);
        } else if ("list".equals(action)) {
            request.setAttribute("appointments", appointmentHandler.getAllAppointments());
            request.getRequestDispatcher("/appointment/list.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            String id = request.getParameter("id");
            request.setAttribute("appointment", findAppointmentById(id));
            request.getRequestDispatcher("/appointment/edit.jsp").forward(request, response);
        } else {
            response.sendRedirect("appointment?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action") : (String) request.getAttribute("action");
        if ("book".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String serviceType = request.getParameter("serviceType");
            String service = request.getParameter("service");
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            String stylist = request.getParameter("stylist");

            if ("VIP Services".equals(serviceType)) {
                // Store pending VIP request in session
                List<String> pendingNotifications = (List<String>) request.getSession().getAttribute("pendingNotifications");
                if (pendingNotifications == null) {
                    pendingNotifications = new ArrayList<>();
                    request.getSession().setAttribute("pendingNotifications", pendingNotifications);
                }
                String notification = "VIP Service Upgrade Request from " + name + "-" + service;
                pendingNotifications.add(notification + "," + name + "," + email + "," + phone + "," + serviceType + "," + service + "," + date + "," + time + "," + stylist);
                request.getSession().setAttribute("pendingNotifications", pendingNotifications);
                response.sendRedirect("customer?action=notifications");
            } else {
                // Regular booking process
                String type = "Regular";
                Customer customer = new Customer(0, name, email, phone, type);
                try {
                    customerHandler.saveCustomer(customer);
                } catch (IOException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/mainIndex.jsp");
                    return;
                }

                int customerId = customer.getId();
                String id = getNextId();
                String fullServiceType = serviceType + " - " + service;
                Appointment appointment = new Appointment(id, customerId, 0, fullServiceType, date, time, stylist);
                try {
                    appointmentHandler.saveAppointment(appointment);
                } catch (IOException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/mainIndex.jsp");
                    return;
                }

                response.sendRedirect("appointment?action=list");
            }
        } else if ("accept".equals(action)) {
            String notification = request.getParameter("notification");
            List<String> pendingNotifications = (List<String>) request.getSession().getAttribute("pendingNotifications");
            if (pendingNotifications != null && pendingNotifications.contains(notification)) {
                String[] parts = notification.split(",");
                String name = parts[1];
                String email = parts[2];
                String phone = parts[3];
                String serviceType = parts[4];
                String service = parts[5];
                String date = parts[6];
                String time = parts[7];
                String stylist = parts[8];

                // Create customer
                Customer customer = new Customer(0, name, email, phone, "VIP");
                try {
                    customerHandler.saveCustomer(customer);
                } catch (IOException e) {
                    e.printStackTrace();
                    response.sendRedirect("customer?action=notifications");
                    return;
                }

                // Create appointment
                int customerId = customer.getId();
                String id = getNextId();
                String fullServiceType = serviceType + " - " + service;
                Appointment appointment = new Appointment(id, customerId, 0, fullServiceType, date, time, stylist);
                try {
                    appointmentHandler.saveAppointment(appointment);
                } catch (IOException e) {
                    e.printStackTrace();
                    response.sendRedirect("customer?action=notifications");
                    return;
                }

                // Remove accepted notification
                pendingNotifications.remove(notification);
                request.getSession().setAttribute("pendingNotifications", pendingNotifications);
                response.sendRedirect("appointment?action=list");
            } else {
                response.sendRedirect("customer?action=notifications");
            }
        } else if ("delete".equals(action)) {
            String notification = request.getParameter("notification");
            List<String> pendingNotifications = (List<String>) request.getSession().getAttribute("pendingNotifications");
            if (pendingNotifications != null && pendingNotifications.contains(notification)) {
                pendingNotifications.remove(notification);
                request.getSession().setAttribute("pendingNotifications", pendingNotifications);
            }
            response.sendRedirect("customer?action=notifications");
        } else if ("cancel".equals(action) || "delete".equals(action)) {
            String id = request.getParameter("id");
            appointmentHandler.deleteAppointment(id);
            response.sendRedirect("appointment?action=list");
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String serviceType = request.getParameter("serviceType");
            String service = request.getParameter("service");
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            String stylist = request.getParameter("stylist");

            String fullServiceType = serviceType + " - " + service;
            System.out.println("Updating date: " + date + ", time: " + time + ", serviceType: " + fullServiceType);
            Appointment appointment = new Appointment(id, customerId, 0, fullServiceType, date, time, stylist);

            updateAppointment(appointment);
            response.sendRedirect("appointment?action=list");
        }
    }

    private Appointment findAppointmentById(String id) {
        try {
            return appointmentHandler.getAllAppointments().stream()
                    .filter(a -> a.getId().equals(id))
                    .findFirst()
                    .orElse(new Appointment("", 0, 0, "", "", "", ""));
        } catch (IOException e) {
            return new Appointment("", 0, 0, "", "", "", "");
        }
    }

    private void updateAppointment(Appointment appointment) throws IOException {
        appointmentHandler.deleteAppointment(appointment.getId());
        appointmentHandler.saveAppointment(appointment);
    }

    private String getNextId() {
        try {
            int maxNum = appointmentHandler.getAllAppointments().stream()
                    .map(Appointment::getId)
                    .filter(id -> id.startsWith("AP"))
                    .map(id -> id.substring(2))
                    .mapToInt(Integer::parseInt)
                    .max()
                    .orElse(0);
            return String.format("AP%02d", maxNum + 1);
        } catch (IOException e) {
            return "AP01";
        }
    }
}