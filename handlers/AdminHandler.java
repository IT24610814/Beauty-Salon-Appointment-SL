package com.example.handlers;

import com.example.models.Admin;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class AdminHandler {
    private String filePath;
    private int lastId = 0;

    public AdminHandler(ServletContext context) {
        Object tempDir = context.getAttribute("javax.servlet.context.tempdir");
        this.filePath = (tempDir != null ? tempDir.toString() : System.getProperty("java.io.tmpdir"))
                + File.separator + "admins.txt";
        System.out.println("AdminHandler: Using file path: " + filePath);
        initializeDefaultAdmin();
        loadLastId();
    }

    private void initializeDefaultAdmin() {
        try {
            List<Admin> admins = getAdmins();
            if (admins.isEmpty()) {
                System.out.println("AdminHandler: No admins found, initializing default admin.");
                Admin defaultAdmin = new Admin(1, "Default Admin", "admin@example.com", "1234567890", "admin", "admin123");
                admins.add(defaultAdmin);
                saveAllAdmins(admins);
            }
        } catch (IOException e) {
            System.out.println("AdminHandler: Error initializing default admin: " + e.getMessage());
        }
    }

    private void loadLastId() {
        try {
            List<Admin> admins = getAdmins();
            if (!admins.isEmpty()) {
                lastId = admins.stream().mapToInt(Admin::getId).max().getAsInt();
            }
        } catch (IOException e) {
            System.out.println("AdminHandler: Error loading last ID: " + e.getMessage());
        }
    }

    public int generateNewId() {
        return ++lastId;
    }

    public List<Admin> getAdmins() throws IOException {
        List<Admin> admins = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",", -1);
                if (parts.length >= 6) { // Assuming id, name, email, phone, username, password
                    try {
                        int id = Integer.parseInt(parts[0].trim());
                        String name = parts[1].trim();
                        String email = parts[2].trim();
                        String phone = parts[3].trim();
                        String username = parts[4].trim();
                        String password = parts[5].trim();
                        admins.add(new Admin(id, name, email, phone, username, password));
                    } catch (NumberFormatException e) {
                        System.out.println("AdminHandler: Skipping invalid line: " + line + ", error: " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("AdminHandler: Error reading admins: " + e.getMessage());
            throw e;
        }
        return admins;
    }

    public Admin getAdminById(int id) throws IOException {
        List<Admin> admins = getAdmins();
        for (Admin admin : admins) {
            if (admin.getId() == id) {
                return admin;
            }
        }
        return null;
    }

    public void addAdmin(Admin admin) throws IOException {
        List<Admin> admins = getAdmins();
        if (admins.stream().anyMatch(a -> a.getId() == admin.getId())) {
            throw new IOException("Admin ID " + admin.getId() + " already exists.");
        }
        admins.add(admin);
        saveAllAdmins(admins);
    }

    public void updateAdmin(Admin updatedAdmin) throws IOException {
        List<Admin> admins = getAdmins();
        boolean found = false;
        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i).getId() == updatedAdmin.getId()) {
                admins.set(i, updatedAdmin);
                found = true;
                break;
            }
        }
        if (!found) {
            throw new IOException("Admin ID " + updatedAdmin.getId() + " not found.");
        }
        saveAllAdmins(admins);
    }

    public void deleteAdmin(int id) throws IOException {
        List<Admin> admins = getAdmins();
        boolean removed = admins.removeIf(admin -> admin.getId() == id);
        if (!removed) {
            throw new IOException("Admin ID " + id + " not found.");
        }
        saveAllAdmins(admins);
    }

    private void saveAllAdmins(List<Admin> admins) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (Admin admin : admins) {
                String line = admin.getId() + "," + 
                             (admin.getName() != null ? admin.getName() : "") + "," + 
                             (admin.getEmail() != null ? admin.getEmail() : "") + "," + 
                             (admin.getPhone() != null ? admin.getPhone() : "") + "," + 
                             (admin.getUsername() != null ? admin.getUsername() : "") + "," + 
                             (admin.getPassword() != null ? admin.getPassword() : "");
                bw.write(line);
                bw.newLine();
            }
            System.out.println("AdminHandler: Successfully saved admins to: " + filePath);
        } catch (IOException e) {
            System.out.println("AdminHandler: Error saving admins: " + e.getMessage());
            throw e;
        }
    }
}