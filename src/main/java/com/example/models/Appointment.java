package com.example.models;

public class Appointment {
    private String id;
    private int customerId;
    private int stylistId;
    private String serviceType;
    private String date;
    private String time;
    private String stylist;

    public Appointment(String id, int customerId, int stylistId, String serviceType, String date, String time, String stylist) {
        this.id = id;
        this.customerId = customerId;
        this.stylistId = stylistId;
        this.serviceType = serviceType;
        this.date = date;
        this.time = time;
        this.stylist = stylist;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getStylistId() {
        return stylistId;
    }

    public void setStylistId(int stylistId) {
        this.stylistId = stylistId;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getDate() {
        return date != null ? date : "-";
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time != null ? time : "-";
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getStylist() {
        return stylist;
    }

    public void setStylist(String stylist) {
        this.stylist = stylist;
    }
}