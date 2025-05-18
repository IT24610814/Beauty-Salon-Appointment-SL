package com.example.handlers;

import com.example.models.Service;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceHandler {
    private String tempFilePath;

    public ServiceHandler(ServletContext context) {
        Object tempDir = context.getAttribute("javax.servlet.context.tempdir");
        this.tempFilePath = (tempDir != null ? tempDir.toString() : System.getProperty("java.io.tmpdir")) + File.separator + "services.txt";
    }

    public void saveService(Service service) throws IOException {
        List<Service> services = readServices();
        services.add(service);
        saveAllServices(services);
    }

    public List<Service> getAllServices() throws IOException {
        return readServices();
    }

    public Service getServiceById(String id) throws IOException {
        List<Service> services = readServices();
        return services.stream().filter(s -> s.getId().equals(id)).findFirst().orElse(null);
    }

    public void updateService(String originalId, Service service) throws IOException {
        List<Service> services = readServices();
        services.removeIf(s -> s.getId().equals(originalId));
        services.add(service);
        saveAllServices(services);
    }

    public void deleteService(String id) throws IOException {
        List<Service> services = readServices();
        services.removeIf(s -> s.getId().equals(id));
        saveAllServices(services);
    }

    private List<Service> readServices() throws IOException {
        List<Service> services = new ArrayList<>();
        File file = new File(tempFilePath);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedReader br = new BufferedReader(new FileReader(tempFilePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",", 6);
                if (parts.length == 6) {
                    try {
                        String id = parts[0];
                        String name = parts[1];
                        String duration = parts[2];
                        double price = Double.parseDouble(parts[3]);
                        String description = parts[4].isEmpty() ? null : parts[4];
                        String type = parts[5];
                        services.add(new Service(id, name, duration, price, description, type));
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing line: " + line + " - " + e.getMessage());
                    }
                }
            }
        } catch (FileNotFoundException e) {
            return new ArrayList<>();
        }
        return services;
    }

    private void saveAllServices(List<Service> services) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(tempFilePath))) {
            for (Service service : services) {
                String description = service.getDescription() != null ? service.getDescription() : "";
                bw.write(service.getId() + "," + service.getName() + "," + service.getDuration() + "," + service.getPrice() + "," + description + "," + service.getType());
                bw.newLine();
            }
        }
    }
}