package com.example.models;

public class Stylist {
    private String id;
    private String name;
    private String specialty;
    private String availability;
    private String type;
    private String imagePath;

    public Stylist(String id, String name, String specialty, String availability, String type, String imagePath) {
        this.id = id;
        this.name = name;
        this.specialty = specialty;
        this.availability = availability;
        this.type = type;
        this.imagePath = imagePath;
    }

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }
    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}