package com.example.handlers;

import com.example.models.Feedback;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackHandler {
    private String filePath;
    private int lastId = 0;

    public FeedbackHandler(ServletContext context) {
        Object tempDir = context.getAttribute("javax.servlet.context.tempdir");
        this.filePath = (tempDir != null ? tempDir.toString() : System.getProperty("java.io.tmpdir"))
                + File.separator + "feedbacks.txt";
        System.out.println("FeedbackHandler: Using file path: " + filePath);
        loadLastId();
    }

    private void loadLastId() {
        try {
            List<Feedback> feedbacks = readFeedbacks();
            if (!feedbacks.isEmpty()) {
                lastId = feedbacks.stream().mapToInt(Feedback::getId).max().getAsInt();
            }
        } catch (IOException e) {
            System.out.println("FeedbackHandler: Error loading last ID: " + e.getMessage());
        }
    }

    public void saveFeedback(Feedback feedback) throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        if (feedbacks.stream().anyMatch(f -> f.getId() == feedback.getId())) {
            throw new IOException("Feedback ID " + feedback.getId() + " already exists.");
        }
        feedbacks.add(feedback);
        saveAllFeedbacks(feedbacks);
    }

    public List<Feedback> getAllFeedbacks() throws IOException {
        return readFeedbacks();
    }

    public Feedback getFeedbackById(int id) throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        return feedbacks.stream().filter(f -> f.getId() == id).findFirst().orElse(null);
    }

    public void updateFeedback(Feedback feedback) throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        for (int i = 0; i < feedbacks.size(); i++) {
            if (feedbacks.get(i).getId() == feedback.getId()) {
                feedbacks.set(i, feedback);
                break;
            }
        }
        saveAllFeedbacks(feedbacks);
    }

    public void deleteFeedback(int id) throws IOException {
        List<Feedback> feedbacks = readFeedbacks();
        feedbacks.removeIf(f -> f.getId() == id);
        saveAllFeedbacks(feedbacks);
    }

    public int generateNewId() {
        return ++lastId;
    }

    private List<Feedback> readFeedbacks() throws IOException {
        List<Feedback> feedbacks = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) {
            System.out.println("FeedbackHandler: Creating new file: " + filePath);
            file.createNewFile();
        }
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",", -1); // Split with no limit to handle trailing commas
                if (parts.length >= 4) {
                    try {
                        int id = Integer.parseInt(parts[0].trim());
                        String customerName = parts[1].trim();
                        // Join all parts between customerName and the last part (rating) as comments
                        StringBuilder commentsBuilder = new StringBuilder();
                        for (int i = 2; i < parts.length - 1; i++) {
                            commentsBuilder.append(parts[i]).append(i < parts.length - 2 ? "," : "");
                        }
                        String comments = commentsBuilder.toString().trim();
                        int rating = Integer.parseInt(parts[parts.length - 1].trim());
                        Feedback feedback = new Feedback(id, customerName, comments, rating);
                        feedbacks.add(feedback);
                    } catch (NumberFormatException e) {
                        System.out.println("FeedbackHandler: Skipping invalid line: " + line + ", error: " + e.getMessage());
                    }
                } else {
                    System.out.println("FeedbackHandler: Skipping malformed line: " + line);
                }
            }
        } catch (FileNotFoundException e) {
            System.out.println("FeedbackHandler: File not found, returning empty list: " + e.getMessage());
            return new ArrayList<>();
        }
        return feedbacks;
    }

    private void saveAllFeedbacks(List<Feedback> feedbacks) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (Feedback feedback : feedbacks) {
                String line = feedback.getId() + "," + feedback.getCustomerName() + "," + feedback.getComments() + "," + feedback.getRating();
                bw.write(line);
                bw.newLine();
            }
            System.out.println("FeedbackHandler: Successfully saved feedbacks to: " + filePath);
        } catch (IOException e) {
            System.out.println("FeedbackHandler: Error saving feedbacks: " + e.getMessage());
            throw e;
        }
    }
}