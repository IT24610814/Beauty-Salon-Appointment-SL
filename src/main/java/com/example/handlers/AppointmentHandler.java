package com.example.handlers;

import com.example.models.Appointment;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentHandler {
    private static final String FILE_PATH = System.getProperty("java.io.tmpdir") + File.separator + "appointments.txt";

    public void saveAppointment(Appointment appointment) throws IOException {
        List<Appointment> appointments = readAppointments();
        appointments.add(appointment);
        saveAllAppointments(appointments);
    }

    public List<Appointment> getAllAppointments() throws IOException {
        return readAppointments();
    }

    public void deleteAppointment(String id) throws IOException {
        List<Appointment> appointments = readAppointments();
        appointments.removeIf(a -> a.getId().equals(id));
        saveAllAppointments(appointments);
    }

    private List<Appointment> readAppointments() throws IOException {
        List<Appointment> appointments = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 7) {
                    try {
                        String id = parts[0].trim();
                        int customerId = Integer.parseInt(parts[1].trim());
                        int stylistId = Integer.parseInt(parts[2].trim());
                        String serviceType = parts[3].trim().isEmpty() ? "-" : parts[3].trim();
                        String date = parts[4].trim().isEmpty() ? "-" : parts[4].trim();
                        String time = parts[5].trim().isEmpty() ? "-" : parts[5].trim();
                        String stylist = parts[6].trim().isEmpty() ? "-" : parts[6].trim();
                        System.out.println("Reading line: " + line);
                        System.out.println("Parsed date: " + date + ", time: " + time);
                        Appointment appointment = new Appointment(id, customerId, stylistId, serviceType, date, time, stylist);
                        appointments.add(appointment);
                    } catch (NumberFormatException e) {
                        System.err.println("Skipping invalid line: " + line + " due to " + e.getMessage());
                    }
                }
            }
        }
        return appointments;
    }

    private void saveAllAppointments(List<Appointment> appointments) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Appointment appointment : appointments) {
                bw.write(appointment.getId() + "," + 
                         appointment.getCustomerId() + "," + 
                         appointment.getStylistId() + "," + 
                         (appointment.getServiceType() != null ? appointment.getServiceType() : "") + "," +
                         (appointment.getDate() != null ? appointment.getDate() : "") + "," +
                         (appointment.getTime() != null ? appointment.getTime() : "") + "," +
                         (appointment.getStylist() != null ? appointment.getStylist() : ""));
                bw.newLine();
            }
        }
    }
}