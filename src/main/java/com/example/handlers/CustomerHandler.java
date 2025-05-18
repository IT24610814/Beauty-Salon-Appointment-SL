package com.example.handlers;

import com.example.models.Customer;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerHandler {
    private static final String FILE_PATH = "/WEB-INF/customers.txt";
    private ServletContext servletContext;

    public CustomerHandler(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public void saveCustomer(Customer customer) throws IOException {
        List<Customer> customers = readCustomers();
        // Generate a new ID if the customer ID is 0 (indicating a new customer)
        if (customer.getId() == 0) {
            int newId = customers.stream()
                    .mapToInt(Customer::getId)
                    .max()
                    .orElse(0) + 1;
            customer.setId(newId);
        }
        customers.add(customer);
        saveAllCustomers(customers);
    }

    public List<Customer> getAllCustomers() throws IOException {
        return readCustomers();
    }

    public Customer getCustomerById(int id) throws IOException {
        List<Customer> customers = readCustomers();
        return customers.stream().filter(c -> c.getId() == id).findFirst().orElse(null);
    }

    public void updateCustomer(Customer customer) throws IOException {
        List<Customer> customers = readCustomers();
        for (int i = 0; i < customers.size(); i++) {
            if (customers.get(i).getId() == customer.getId()) {
                customers.set(i, customer);
                break;
            }
        }
        saveAllCustomers(customers);
    }

    public void deleteCustomer(int id) throws IOException {
        List<Customer> customers = readCustomers();
        customers.removeIf(c -> c.getId() == id);
        saveAllCustomers(customers);
        System.out.println("Deleted customer with ID: " + id + " from file: " + servletContext.getRealPath(FILE_PATH));
    }

    private List<Customer> readCustomers() throws IOException {
        List<Customer> customers = new ArrayList<>();
        String filePath = servletContext.getRealPath(FILE_PATH);
        File file = new File(filePath);
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    customers.add(new Customer(Integer.parseInt(parts[0]), parts[1], parts[2], parts[3], parts[4]));
                } else if (parts.length == 4) {
                    customers.add(new Customer(Integer.parseInt(parts[0]), parts[1], parts[2], parts[3], "Regular"));
                }
            }
        } catch (FileNotFoundException e) {
            return customers;
        }
        return customers;
    }

    private void saveAllCustomers(List<Customer> customers) throws IOException {
        String filePath = servletContext.getRealPath(FILE_PATH);
        File file = new File(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            for (Customer customer : customers) {
                bw.write(customer.getId() + "," + customer.getName() + "," + customer.getEmail() + "," + customer.getPhone() + "," + customer.getType());
                bw.newLine();
            }
        }
    }
}