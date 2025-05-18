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
<%@ page import="com.example.models.Feedback" %>
<html>
<head>
    <title>Moderate Feedback</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg w-full max-w-md">
    <h1 class="text-2xl font-bold mb-4">Moderate Feedback</h1>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <% Feedback feedback = (Feedback) request.getAttribute("feedback"); %>
    <% if (feedback == null) { %>
    <p class="text-red-500 mb-4">Error: Feedback not found. Please go back and try again.</p>
    <a href="feedback?action=display" class="text-blue-500 mt-4 inline-block">Back to Feedback List</a>
    <% } else { %>
    <form action="feedback" method="post" class="space-y-4">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${feedback.id}">
        <div>
            <label class="block">Customer Name:</label>
            <input type="text" name="customerId" value="${feedback.customerName}" required class="border p-2 w-full rounded">
        </div>
        <div>
            <label class="block">Comments:</label>
            <textarea name="comments" required class="border p-2 w-full rounded">${feedback.comments}</textarea>
        </div>
        <div>
            <label class="block">Rating (1-5):</label>
            <input type="number" name="rating" value="${feedback.rating}" min="1" max="5" required class="border p-2 w-full rounded">
        </div>
        <button type="submit" class="bg-indigo-500 text-white px-4 py-2 rounded hover:bg-indigo-600 w-full">Update Feedback</button>
    </form>
    <a href="feedback?action=display" class="text-blue-500 mt-4 inline-block">Back to Feedback List</a>
    <% } %>
</div>
</body>
</html>