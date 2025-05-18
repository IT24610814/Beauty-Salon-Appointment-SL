package com.example.servlets;

import com.example.handlers.FeedbackHandler;
import com.example.models.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    private FeedbackHandler feedbackHandler;

    @Override
    public void init() throws ServletException {
        feedbackHandler = new FeedbackHandler(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            request.getRequestDispatcher("/feedback/submit.jsp").forward(request, response);
        } else if ("display".equals(action)) {
            try {
                request.setAttribute("feedback", feedbackHandler.getAllFeedbacks());
                request.getRequestDispatcher("/feedback/display.jsp").forward(request, response);
            } catch (IOException e) {
                System.out.println("FeedbackServlet: Error retrieving feedbacks: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Error retrieving feedback: " + e.getMessage());
                request.getRequestDispatcher("/feedback/display.jsp").forward(request, response);
            }
        } else if ("moderate".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Feedback feedback = feedbackHandler.getFeedbackById(id);
                if (feedback == null) {
                    request.setAttribute("error", "Feedback with ID " + id + " not found.");
                    request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
                } else {
                    request.setAttribute("feedback", feedback);
                    request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                System.out.println("FeedbackServlet: Invalid feedback ID format: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Invalid feedback ID format.");
                request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("FeedbackServlet: Error retrieving feedback: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Error retrieving feedback: " + e.getMessage());
                request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            try {
                int id = feedbackHandler.generateNewId();
                String customerName = request.getParameter("customerName").trim();
                String comments = request.getParameter("comments").trim().replaceAll("\n", " ");
                int rating = Integer.parseInt(request.getParameter("rating").trim());

                if (rating < 1 || rating > 5) {
                    throw new IllegalArgumentException("Rating must be between 1 and 5.");
                }

                Feedback feedback = new Feedback(id, customerName, comments, rating);
                feedbackHandler.saveFeedback(feedback);
                System.out.println("FeedbackServlet: Successfully saved feedback with ID " + id + " at " + request.getRequestURI());
                response.sendRedirect(request.getContextPath() + "/mainIndex.jsp");
            } catch (NumberFormatException e) {
                System.out.println("FeedbackServlet: Invalid input format: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Invalid input format: " + e.getMessage());
                request.getRequestDispatcher("/feedback/submit.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                System.out.println("FeedbackServlet: Rating validation failed: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/feedback/submit.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("FeedbackServlet: Error submitting feedback: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Error submitting feedback: " + e.getMessage());
                request.getRequestDispatcher("/feedback/submit.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id").trim());
                String customerName = request.getParameter("customerId").trim();
                String comments = request.getParameter("comments").trim().replaceAll("\n", " ");
                int rating = Integer.parseInt(request.getParameter("rating").trim());
                Feedback feedback = new Feedback(id, customerName, comments, rating);
                feedbackHandler.updateFeedback(feedback);
                System.out.println("FeedbackServlet: Successfully updated feedback with ID " + id + " at " + request.getRequestURI());
                response.sendRedirect(request.getContextPath() + "/feedback?action=display");
            } catch (NumberFormatException e) {
                System.out.println("FeedbackServlet: Invalid input format during update: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Invalid input format.");
                request.setAttribute("feedback", feedbackHandler.getFeedbackById(Integer.parseInt(request.getParameter("id"))));
                request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("FeedbackServlet: Error updating feedback: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Error updating feedback: " + e.getMessage());
                request.setAttribute("feedback", feedbackHandler.getFeedbackById(Integer.parseInt(request.getParameter("id"))));
                request.getRequestDispatcher("/feedback/moderate.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id").trim());
                feedbackHandler.deleteFeedback(id);
                System.out.println("FeedbackServlet: Successfully deleted feedback with ID " + id + " at " + request.getRequestURI());
                response.sendRedirect(request.getContextPath() + "/feedback?action=display");
            } catch (NumberFormatException e) {
                System.out.println("FeedbackServlet: Invalid feedback ID format during delete: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Invalid feedback ID format.");
                request.getRequestDispatcher("/feedback/display.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("FeedbackServlet: Error deleting feedback: " + e.getMessage() + " at " + request.getRequestURI());
                request.setAttribute("error", "Error deleting feedback: " + e.getMessage());
                request.getRequestDispatcher("/feedback/display.jsp").forward(request, response);
            }
        }
    }
}
