package com.example.servlets;

import com.example.handlers.StylistHandler;
import com.example.models.Stylist;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/stylist")
@MultipartConfig
public class StylistServlet extends HttpServlet {
    private StylistHandler stylistHandler;

    @Override
    public void init() throws ServletException {
        stylistHandler = new StylistHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("list".equals(action)) {
            request.setAttribute("stylists", stylistHandler.getAllStylists());
            request.getRequestDispatcher("/stylist/list.jsp").forward(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/stylist/register.jsp").forward(request, response);
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            Stylist stylist = stylistHandler.getStylistById(id);
            if (stylist != null) {
                request.setAttribute("stylist", stylist);
                request.getRequestDispatcher("/stylist/update.jsp").forward(request, response);
            } else {
                response.sendRedirect("stylist?action=list");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String specialty = request.getParameter("specialty");
            String availability = request.getParameter("availability");
            String type = request.getParameter("type");

            Part imagePart = request.getPart("image");
            String imagePath = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = id + "_" + System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + "images/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                imagePath = "images/" + fileName;
                try {
                    imagePart.write(uploadPath + fileName);
                } catch (IOException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to upload image: " + e.getMessage());
                    request.getRequestDispatcher("/stylist/register.jsp").forward(request, response);
                    return;
                }
            }

            Stylist stylist = new Stylist(id, name, specialty, availability, type, imagePath);
            boolean added = stylistHandler.addStylist(stylist);
            if (added) {
                response.sendRedirect("stylist?action=list");
            } else {
                request.setAttribute("error", "Failed to add stylist. ID might already exist or there was an error saving the data.");
                request.getRequestDispatcher("/stylist/register.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String specialty = request.getParameter("specialty");
            String availability = request.getParameter("availability");
            String type = request.getParameter("type");

            Part imagePart = request.getPart("image");
            String imagePath = null;
            Stylist existingStylist = stylistHandler.getStylistById(id);
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = id + "_" + System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + "images/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                imagePath = "images/" + fileName;
                try {
                    imagePart.write(uploadPath + fileName);
                    // Delete old image if it exists
                    if (existingStylist != null && existingStylist.getImagePath() != null) {
                        File oldImage = new File(getServletContext().getRealPath("") + existingStylist.getImagePath());
                        if (oldImage.exists()) oldImage.delete();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to upload image: " + e.getMessage());
                    request.getRequestDispatcher("/stylist/update.jsp").forward(request, response);
                    return;
                }
            } else if (existingStylist != null) {
                imagePath = existingStylist.getImagePath();
            }

            Stylist stylist = new Stylist(id, name, specialty, availability, type, imagePath);
            boolean updated = stylistHandler.updateStylist(stylist);
            if (updated) {
                response.sendRedirect("stylist?action=list");
            } else {
                request.setAttribute("error", "Failed to update stylist.");
                request.getRequestDispatcher("/stylist/update.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            Stylist stylist = stylistHandler.getStylistById(id);
            boolean deleted = stylistHandler.deleteStylist(id);
            if (deleted) {
                if (stylist != null && stylist.getImagePath() != null) {
                    File image = new File(getServletContext().getRealPath("") + stylist.getImagePath());
                    if (image.exists()) image.delete();
                }
                response.sendRedirect("stylist?action=list");
            } else {
                response.sendRedirect("stylist?action=list");
            }
        }
    }
}