<script type="text/javascript">
        var gk_isXlsx = false;
        var gk_xlsxFileLookup = {};
        var gk_fileData = {};
        function filledCell(cell) {
          return cell !== '' && cell != null;
        }
        function loadFileData(filename) {
        if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
            try {
                var workbook = XLSX.read(gk_fileData[filename], { type: 'base64' });
                var firstSheetName = workbook.SheetNames[0];
                var worksheet = workbook.Sheets[firstSheetName];

                // Convert sheet to JSON to filter blank rows
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                // Filter out blank rows (rows where all cells are empty, null, or undefined)
                var filteredData = jsonData.filter(row => row.some(filledCell));

                // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
                var headerRowIndex = filteredData.findIndex((row, index) =>
                  row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                // Fallback
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                  headerRowIndex = 0;
                }

                // Convert filtered JSON back to CSV
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex)); // Create a new sheet from filtered array of arrays
                csv = XLSX.utils.sheet_to_csv(csv, { header: 1 });
                return csv;
            } catch (e) {
                console.error(e);
                return "";
            }
        }
        return gk_fileData[filename] || "";
        }
        </script><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.models.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Management - Beauty Salon Sri Lanka</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script type="text/javascript">
        var gk_isXlsx = false;
        var gk_xlsxFileLookup = {};
        var gk_fileData = {};
        function filledCell(cell) {
          return cell !== '' && cell != null;
        }
        function loadFileData(filename) {
        if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
            try {
                var workbook = XLSX.read(gk_fileData[filename], { type: 'base64' });
                var firstSheetName = workbook.SheetNames[0];
                var worksheet = workbook.Sheets[firstSheetName];

                // Convert sheet to JSON to filter blank rows
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                // Filter out blank rows (rows where all cells are empty, null, or undefined)
                var filteredData = jsonData.filter(row => row.some(filledCell));

                // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
                var headerRowIndex = filteredData.findIndex((row, index) =>
                  row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                // Fallback
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                  headerRowIndex = 0;
                }

                // Convert filtered JSON back to CSV
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex)); // Create a new sheet from filtered array of arrays
                csv = XLSX.utils.sheet_to_csv(csv, { header: 1 });
                return csv;
            } catch (e) {
                console.error(e);
                return "";
            }
        }
        return gk_fileData[filename] || "";
        }
    </script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg1.jpg');
            background-size: cover;
            background-position: center;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .bell-button {
            font-size: 1.5rem;
            cursor: pointer;
            color: #4a5568;
            background: none;
            border: none;
            padding: 0.5rem;
        }
        .bell-button:hover {
            color: #2563eb;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-100 flex flex-col items-center">
<div class="bg-white bg-opacity-80 p-8 rounded-lg shadow-lg w-full max-w-5xl mt-8">
    <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">Customer Management</h1>

    <!-- Search Bar and Bell Icon -->
    <div class="mb-6 flex justify-between items-center">
        <div>
            <form action="customer" method="get" class="flex">
                <input type="hidden" name="action" value="list">
                <input type="text" name="search" placeholder="Search by name, email, or phone" class="border p-2 rounded-l" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded-r hover:bg-blue-600">Search</button>
            </form>
        </div>
        <button class="bell-button" title="Notifications" onclick="window.location.href='customer?action=notifications'"><i class="fas fa-bell"></i></button>
    </div>

    <!-- Customer List Table -->
    <table class="w-full border border-gray-300">
        <thead>
        <tr class="bg-gray-200">
            <th class="border px-4 py-2">ID</th>
            <th class="border px-4 py-2">Name</th>
            <th class="border px-4 py-2">Email</th>
            <th class="border px-4 py-2">Phone</th>
            <th class="border px-4 py-2">Type</th>
            <th class="border px-4 py-2">Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Customer> customers = (List<Customer>) request.getAttribute("customers");
            String searchQuery = request.getParameter("search");
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                customers = customers.stream()
                        .filter(c -> c.getName().toLowerCase().contains(searchQuery.toLowerCase()) ||
                                c.getEmail().toLowerCase().contains(searchQuery.toLowerCase()) ||
                                c.getPhone().toLowerCase().contains(searchQuery.toLowerCase()))
                        .collect(Collectors.toList());
            }
            if (customers != null && !customers.isEmpty()) {
                for (Customer customer : customers) { %>
        <tr>
            <td class="border px-4 py-2"><%="CU" + String.format("%02d", customer.getId()) %></td>
            <td class="border px-4 py-2"><%= customer.getName() %></td>
            <td class="border px-4 py-2"><%= customer.getEmail() %></td>
            <td class="border px-4 py-2"><%= customer.getPhone() %></td>
            <td class="border px-4 py-2"><%= customer.getType() %></td>
            <td class="border px-4 py-2">
                <a href="customer?action=update&id=<%= customer.getId() %>" class="text-blue-500 hover:underline">Edit</a>
                <form action="customer" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this customer?')">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= customer.getId() %>">
                    <button type="submit" class="text-red-500 hover:underline ml-2">Delete</button>
                </form>
            </td>
        </tr>
        <% }
        } else { %>
        <tr>
            <td colspan="6" class="border px-4 py-2 text-center">No customers found.</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Buttons -->
    <div class="mt-6 flex space-x-4">
        <a href="customer?action=register" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add New Customer</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>