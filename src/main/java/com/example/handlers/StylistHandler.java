package com.example.handlers;

import com.example.models.Stylist;
import jakarta.servlet.ServletContext;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class StylistHandler {
    private final String filePath;

    public StylistHandler(ServletContext context) {
        this.filePath = context.getRealPath("") + "WEB-INF/temp/stylists.txt";
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                file.getParentFile().mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Stylist> getAllStylists() {
        List<Stylist> stylists = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 5) {
                    String id = parts[0].trim();
                    String name = parts[1].trim();
                    String specialty = parts[2].trim();
                    String availability = parts[3].trim();
                    String type = parts[4].trim();
                    String imagePath = parts.length > 5 ? parts[5].trim() : null;
                    if (!id.isEmpty() && !name.isEmpty()) {
                        stylists.add(new Stylist(id, name, specialty, availability, type, imagePath));
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stylists;
    }

    public boolean addStylist(Stylist stylist) {
        List<Stylist> stylists = getAllStylists();
        for (Stylist s : stylists) {
            if (s.getId().equals(stylist.getId())) return false;
        }
        stylists.add(stylist);
        return writeStylists(stylists);
    }

    public boolean updateStylist(Stylist stylist) {
        List<Stylist> stylists = getAllStylists();
        for (int i = 0; i < stylists.size(); i++) {
            if (stylists.get(i).getId().equals(stylist.getId())) {
                stylists.set(i, stylist);
                return writeStylists(stylists);
            }
        }
        return false;
    }

    public boolean deleteStylist(String id) {
        List<Stylist> stylists = getAllStylists();
        boolean removed = stylists.removeIf(stylist -> stylist.getId().equals(id));
        if (removed) {
            return writeStylists(stylists);
        }
        return false;
    }

    public Stylist getStylistById(String id) {
        return getAllStylists().stream().filter(stylist -> stylist.getId().equals(id)).findFirst().orElse(null);
    }

    private boolean writeStylists(List<Stylist> stylists) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (Stylist stylist : stylists) {
                String imagePath = stylist.getImagePath() != null ? stylist.getImagePath() : "";
                bw.write(String.format("%s,%s,%s,%s,%s,%s",
                        stylist.getId(),
                        stylist.getName(),
                        stylist.getSpecialty(),
                        stylist.getAvailability(),
                        stylist.getType(),
                        imagePath));
                bw.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}