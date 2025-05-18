package com.example.models;

public class Customer {
    private int id;
    private String name;
    private String email;
    private String phone;
    private String preferredStylist;
    private String type; // New field for Regular/VIP

    public Customer(int id, String name, String email, String phone, String preferredStylist) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.preferredStylist = preferredStylist;
        this.type = "Regular"; // Default type
    }

    public Customer(int id, String name, String email, String phone, String preferredStylist, String type) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.preferredStylist = preferredStylist;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

     public String getPreferredStylist() {
        return preferredStylist;
    }

    public void setPreferredStylist(String preferredStylist) {
        this.preferredStylist = preferredStylist;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
