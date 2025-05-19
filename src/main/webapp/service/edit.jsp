
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.models.Service" %>
<html>
<head>
    <title>Edit Service</title>
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
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg max-w-lg w-full">
    <h1 class="text-2xl font-bold mb-4 text-gray-800">Edit Service</h1>
    <%
        Service service = (Service) request.getAttribute("service");
        if (service == null) {
            out.println("<p class='text-red-500 mb-4'>Service not found!</p>");
        } else {
    %>
    <% if (request.getAttribute("error") != null) { %>
        <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="service" method="post" class="space-y-4">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="originalId" value="<%= service.getId() %>">
        <div>
            <label class="block text-gray-700">Name:</label>
            <input type="text" name="name" value="<%= service.getName() %>" required class="border p-2 w-full rounded focus:outline-none focus:ring-2 focus:ring-purple-500">
        </div>
        <div>
            <label class="block text-gray-700">Duration (e.g., 45-90):</label>
            <input type="text" name="duration" value="<%= service.getDuration() %>" required class="border p-2 w-full rounded focus:outline-none focus:ring-2 focus:ring-purple-500" pattern="\d+-\d+" title="Duration must be in format number-number (e.g., 45-90)">
        </div>
        <div>
            <label class="block text-gray-700">Price (LKR):</label>
            <input type="number" step="0.01" name="price" value="<%= String.format("%.2f", service.getPrice()) %>" required class="border p-2 w-full rounded focus:outline-none focus:ring-2 focus:ring-purple-500">
        </div>
        <div>
            <label class="block text-gray-700">Description:</label>
            <textarea name="description" class="border p-2 w-full rounded focus:outline-none focus:ring-2 focus:ring-purple-500" rows="4"><%= service.getDescription() != null ? service.getDescription() : "" %></textarea>
        </div>
        <div>
            <label class="block text-gray-700">Type:</label>
            <select name="type" class="border p-2 w-full rounded focus:outline-none focus:ring-2 focus:ring-purple-500">
                <option value="Hair Care" <%= service.getType().equals("Hair Care") ? "selected" : "" %>>Hair Care</option>
                <option value="Facial Care" <%= service.getType().equals("Facial Care") ? "selected" : "" %>>Facial Care</option>
                <option value="Manicure Services" <%= service.getType().equals("Manicure Services") ? "selected" : "" %>>Manicure Services</option>
                <option value="Pedicure Services" <%= service.getType().equals("Pedicure Services") ? "selected" : "" %>>Pedicure Services</option>
                <option value="VIP Services" <%= service.getType().equals("VIP Services") ? "selected" : "" %>>VIP Services</option>
            </select>
        </div>
        <button type="submit" class="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600 w-full">Update Service</button>
    </form>
    <% } %>
    <a href="service?action=list" class="text-blue-500 mt-4 inline-block hover:underline">Back to Service List</a>
</div>
</body>
</html>
