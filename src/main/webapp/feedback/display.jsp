type="text/javascript">
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
<%@ page import="java.util.List, com.example.models.Feedback" %>
<html>
<head>
    <title>Feedback Display</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg1.jpg');
            background-size: cover;
            background-position: center;
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
    </style>
</head>
<body class="min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg">
    <h1 class="text-2xl font-bold mb-4">Feedback List</h1>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <div class="table-container">
        <table class="w-full border">
            <thead>
            <tr class="bg-gray-200">
                <th class="border p-2">ID</th>
                <th class="border p-2">Customer Name</th>
                <th class="border p-2">Comments</th>
                <th class="border p-2">Rating</th>
                <th class="border p-2">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedback");
                if (feedbackList != null && !feedbackList.isEmpty()) {
                    for (Feedback feedback : feedbackList) {
                        String id = "FE" + String.format("%02d", feedback.getId());
            %>
            <tr>
                <td class="border p-2"><%= id %></td>
                <td class="border p-2"><%= feedback.getCustomerName() %></td>
                <td class="border p-2"><%= feedback.getComments() %></td>
                <td class="border p-2"><%= feedback.getRating() %></td>
                <td class="border p-2">
                    <a href="feedback?action=moderate&id=<%= feedback.getId() %>" class="text-blue-500 hover:underline">Edit</a>
                    <form action="feedback" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this feedback?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= feedback.getId() %>">
                        <button type="submit" class="text-red-500 hover:underline">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
            <% } else { %>
            <tr>
                <td colspan="5" class="border p-2 text-center">No feedback found.</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <div class="mt-4 space-x-4">
        <a href="${pageContext.request.contextPath}/feedback?action=submit" class="bg-indigo-500 text-white px-4 py-2 rounded hover:bg-indigo-600">Submit New Feedback</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>
