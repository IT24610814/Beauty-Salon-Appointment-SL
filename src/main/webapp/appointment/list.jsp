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
<%@ page import="com.example.models.Appointment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Management - Beauty Salon Sri Lanka</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
        th, td {
            white-space: nowrap; /* Prevent wrapping for all columns by default */
        }
        td.service-column {
            white-space: normal; /* Allow wrapping only for Service column */
            word-wrap: break-word; /* Ensure long words break */
        }
    </style>
</head>
<body class="min-h-screen bg-gray-100 flex flex-col items-center">
<div class="bg-white bg-opacity-80 p-8 rounded-lg shadow-lg w-full max-w-5xl mt-8">
    <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">Appointment Management</h1>

    <!-- Appointment List Table -->
    <table class="w-full border border-gray-300">
        <thead>
        <tr class="bg-gray-200">
            <th class="border px-4 py-2">ID</th>
            <th class="border px-4 py-2">Customer ID</th>
            <th class="border px-4 py-2">Service Type</th>
            <th class="border px-4 py-2">Service</th>
            <th class="border px-4 py-2">Date</th>
            <th class="border px-4 py-2">Time</th>
            <th class="border px-4 py-2">Stylist</th>
            <th class="border px-4 py-2">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments"); %>
        <% if (appointments != null && !appointments.isEmpty()) { %>
            <% for (Appointment appointment : appointments) { %>
            <tr>
                <td class="border px-4 py-2"><%= appointment.getId() %></td>
                <td class="border px-4 py-2"><%="CU" + String.format("%02d", appointment.getCustomerId()) %></td>
                <td class="border px-4 py-2"><%= appointment.getServiceType().split(" - ")[0] %></td>
                <td class="border px-4 py-2 service-column"><%= appointment.getServiceType().split(" - ").length > 1 ? appointment.getServiceType().split(" - ")[1] : "-" %></td>
                <td class="border px-4 py-2"><%= appointment.getDate() %></td>
                <td class="border px-4 py-2"><%= appointment.getTime() %></td>
                <td class="border px-4 py-2"><%= appointment.getStylist() %></td>
                <td class="border px-4 py-2">
                    <a href="appointment?action=edit&id=<%= appointment.getId() %>" class="text-blue-500 hover:underline">Edit</a>
                    <form action="appointment" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment?')">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                        <button type="submit" class="text-red-500 hover:underline ml-2">Cancel</button>
                    </form>
                </td>
            </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="8" class="border px-4 py-2 text-center">No appointments found.</td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Buttons -->
    <div class="mt-6 flex space-x-4">
        <a href="appointment?action=book" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Book New Appointment</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>