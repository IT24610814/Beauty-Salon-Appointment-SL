package com.example.models;

public class Feedback {
    private int id;
    private String customerName; // Changed from int customerId to String customerName
    private String comments;
    private int rating; // 1-5

    public Feedback(int id, String customerName, String comments, int rating) {
        this.id = id;
        this.customerName = customerName;
        this.comments = comments;
        this.rating = rating;
    }

    public int getId() { return id; }
    public String getCustomerName() { return customerName; } // Changed from getCustomerId
    public String getComments() { return comments; }
    public int getRating() { return rating; }
    public void setComments(String comments) { this.comments = comments; }
    public void setRating(int rating) { this.rating = rating; }
    public void setCustomerName(String customerName) { this.customerName = customerName; } // Added setter

    public String displayFeedback() {
        return "Rating: " + rating + "/5, Comments: " + comments;
    }
}
