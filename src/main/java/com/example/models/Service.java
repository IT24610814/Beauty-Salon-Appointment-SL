package com.example.models;

public class Service {
    protected String id;
    protected String name;
    protected String duration;
    protected double price;
    protected String description;
    protected String type;

    public Service(String id, String name, String duration, double price, String description, String type) {
        this.id = id;
        this.name = name;
        this.duration = duration;
        this.price = price;
        this.description = description;
        this.type = type;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDuration() {
        return duration;
    }

    public double getPrice() {
        return price;
    }

    public String getDescription() {
        return description;
    }

    public String getType() {
        return type;
    }
}