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
<%@ page import="com.example.models.Stylist" %>
<html>
<head>
    <title>Update Stylist</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg1.jpg');
            background-size: cover;
            background-position: center;
        }
        .form-container {
            background: rgba(255, 255, 255, 0.8);
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen">
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
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                var filteredData = jsonData.filter(row => row.some(filledCell));
                var headerRowIndex = filteredData.findIndex((row, index) =>
                    row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                    headerRowIndex = 0;
                }
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
<div class="form-container p-6 rounded-lg shadow-lg w-full max-w-md">
    <h1 class="text-2xl font-bold mb-4 text-center">Update Stylist</h1>
    <% if (request.getAttribute("error") != null) { %>
        <p class="text-red-500 mb-4 text-center"><%= request.getAttribute("error") %></p>
    <% } %>
    <% Stylist stylist = (Stylist) request.getAttribute("stylist"); %>
    <% if (stylist != null) { %>
        <form action="stylist" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= stylist.getId() %>">
            <div class="mb-4">
                <label class="block text-black">ID</label>
                <input type="text" name="id" value="<%= stylist.getId() %>" readonly class="w-full p-2 border rounded mt-1" pattern="ST[0-9]{2}">
            </div>
            <div class="mb-4">
                <label class="block text-black">Name</label>
                <input type="text" name="name" value="<%= stylist.getName() %>" required class="w-full p-2 border rounded mt-1">
            </div>
            <div class="mb-4">
                <label class="block text-black">Specialty</label>
                <select name="specialty" required class="w-full p-2 border rounded mt-1">
                    <option value="Hair Care" <%= "Hair Care".equals(stylist.getSpecialty()) ? "selected" : "" %>>Hair Care</option>
                    <option value="Facial Care" <%= "Facial Care".equals(stylist.getSpecialty()) ? "selected" : "" %>>Facial Care</option>
                    <option value="Manicure Services" <%= "Manicure Services".equals(stylist.getSpecialty()) ? "selected" : "" %>>Manicure Services</option>
                    <option value="Pedicure Services" <%= "Pedicure Services".equals(stylist.getSpecialty()) ? "selected" : "" %>>Pedicure Services</option>
                    <option value="VIP Services" <%= "VIP Services".equals(stylist.getSpecialty()) ? "selected" : "" %>>VIP Services</option>
                </select>
            </div>
            <div class="mb-4">
                <label class="block text-black">Availability</label>
                <select name="availability" required class="w-full p-2 border rounded mt-1">
                    <option value="8:00-12:00" <%= "8:00-12:00".equals(stylist.getAvailability()) ? "selected" : "" %>>8:00 AM - 12:00 PM</option>
                    <option value="1:00-5:00" <%= "1:00-5:00".equals(stylist.getAvailability()) ? "selected" : "" %>>1:00 PM - 5:00 PM</option>
                </select>
            </div>
            <div class="mb-4">
                <label class="block text-black">Type</label>
                <select name="type" required class="w-full p-2 border rounded mt-1">
                    <option value="Senior" <%= "Senior".equals(stylist.getType()) ? "selected" : "" %>>Senior</option>
                    <option value="Junior" <%= "Junior".equals(stylist.getType()) ? "selected" : "" %>>Junior</option>
                </select>
            </div>
            <div class="mb-4">
                <label class="block text-black">Image</label>
                <input type="file" name="image" accept="image/*" class="w-full p-2 border rounded mt-1">
                <% if (stylist.getImagePath() != null) { %>
                    <p class="text-gray-600 mt-2">Current Image: <%= stylist.getImagePath() %></p>
                <% } %>
            </div>
            <button type="submit" class="w-full bg-yellow-500 text-white p-2 rounded hover:bg-yellow-600">Update</button>
        </form>
    <% } else { %>
        <p class="text-red-500">Stylist not found!</p>
    <% } %>
    <div class="mt-4 text-center">
        <a href="stylist?action=list" class="text-blue-500 hover:underline">Back to List</a>
    </div>
</div>
</body>
</html>