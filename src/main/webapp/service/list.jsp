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
        </script><%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.models.Service" %>
<html>
<head>
    <title>Service List</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg');
            background-size: cover;
            background-position: center;
        }
        .no-wrap {
            white-space: nowrap;
        }
        .table-container {
            max-height: 400px;
            overflow-y: auto;
            display: block;
        }
        table {
            width: 100%;
        }
        thead {
            position: sticky;
            top: 0;
            background-color: #e5e7eb;
            z-index: 1;
        }
        .description-column {
            width: 50%; /* Increased to 50% to utilize the wider white box */
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg w-full max-w-6xl"> <!-- Increased max-width to 6xl -->
    <h1 class="text-2xl font-bold mb-4">Services</h1>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <div class="table-container">
        <table class="w-full border-collapse border">
            <thead>
            <tr class="bg-gray-200">
                <th class="border p-2">ID</th>
                <th class="border p-2">Name</th>
                <th class="border p-2">Duration</th>
                <th class="border p-2">Price (LKR)</th>
                <th class="border p-2 description-column">Description</th>
                <th class="border p-2">Type</th>
                <th class="border p-2">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Service> services = (List<Service>) request.getAttribute("services");
                if (services != null && !services.isEmpty()) {
                    for (Service service : services) {
            %>
            <tr>
                <td class="border p-2 no-wrap align-middle"><%= service.getId() %></td>
                <td class="border p-2 no-wrap align-middle"><%= service.getName() %></td>
                <td class="border p-2 no-wrap align-middle"><%= service.getDuration() %> mins</td>
                <td class="border p-2 no-wrap align-middle"><%= String.format("%.2f", service.getPrice()) %></td>
                <td class="border p-2 description-column"><%= service.getDescription() != null ? service.getDescription() : "" %></td>
                <td class="border p-2 no-wrap align-middle"><%= service.getType() %></td>
                <td class="border p-2 no-wrap align-middle">
                    <div class="flex justify-center space-x-2">
                        <a href="service?action=edit&id=<%= service.getId() %>" class="text-blue-500 bg-blue-100 px-2 py-1 rounded hover:bg-blue-200">Edit</a>
                        <a href="service?action=delete&id=<%= service.getId() %>" onclick="return confirm('Are you sure you want to delete this service?')" class="text-red-500 bg-red-100 px-2 py-1 rounded hover:bg-red-200">Delete</a>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7" class="border p-2 text-center">No services found.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <div class="mt-4 space-x-4">
        <a href="service?action=add" class="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600">Add New Service</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>