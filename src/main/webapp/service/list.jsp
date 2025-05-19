<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.models.Service" %>
<html>
<head>
    <title>Services</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
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
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex));
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
            background-image: url('${pageContext.request.contextPath}/images/salon-bg2.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg max-w-4xl w-full">
    <h1 class="text-2xl font-bold mb-4 text-gray-800">Services</h1>
    <% if (request.getAttribute("error") != null) { %>
        <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <div class="overflow-x-auto">
        <table class="w-full border-collapse">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border p-2 text-left text-gray-700">ID</th>
                    <th class="border p-2 text-left text-gray-700">Name</th>
                    <th class="border p-2 text-left text-gray-700">Duration</th>
                    <th class="border p-2 text-left text-gray-700">Price (LKR)</th>
                    <th class="border p-2 text-left text-gray-700">Description</th>
                    <th class="border p-2 text-left text-gray-700">Type</th>
                    <th class="border p-2 text-left text-gray-700">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% List<Service> services = (List<Service>) request.getAttribute("services");
                   if (services != null && !services.isEmpty()) {
                       for (Service service : services) { %>
                    <tr class="hover:bg-gray-50">
                        <td class="border p-2"><%= service.getId() %></td>
                        <td class="border p-2"><%= service.getName() %></td>
                        <td class="border p-2"><%= service.getDuration() %> mins</td>
                        <td class="border p-2"><%= String.format("%.2f", service.getPrice()) %></td>
                        <td class="border p-2"><%= service.getDescription() != null ? service.getDescription() : "" %></td>
                        <td class="border p-2"><%= service.getType() %></td>
                        <td class="border p-2 flex space-x-2">
                            <a href="${pageContext.request.contextPath}/service?action=edit&id=<%= service.getId() %>" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Edit</a>
                            <a href="${pageContext.request.contextPath}/service?action=delete&id=<%= service.getId() %>" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600" onclick="return confirm('Are you sure you want to delete this service?')">Delete</a>
                        </td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="7" class="border p-2 text-center text-gray-600">No services found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <div class="mt-4 flex space-x-4">
        <a href="${pageContext.request.contextPath}/service?action=add" class="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600">Add New Service</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>
