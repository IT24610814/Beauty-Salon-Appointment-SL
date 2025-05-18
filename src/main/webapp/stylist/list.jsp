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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.models.Stylist, com.example.handlers.StylistHandler" %>
<html>
<head>
    <title>Stylist List</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $(".delete-btn").click(function(e) {
                e.preventDefault();
                var id = $(this).data("id");
                if (confirm("Are you sure you want to delete this stylist?")) {
                    $.ajax({
                        url: "stylist?action=delete&id=" + id,
                        type: "POST",
                        success: function() {
                            $("#stylist-row-" + id).remove();
                            if ($("table tbody tr").length === 0) {
                                $("table tbody").html("<tr><td colspan='6' class='py-3 px-6 text-center'>No stylists available.</td></tr>");
                            }
                        },
                        error: function() {
                            alert("Error deleting stylist. Please try again.");
                        }
                    });
                }
            });
        });
    </script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg');
            background-size: cover;
            background-position: center;
        }
        .container {
            background: rgba(255, 255, 255, 0.7);
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        table {
            background: transparent;
            border-collapse: collapse; /* Ensures smooth inner borders */
        }
        td, th {
            border: #e5e7eb; /* Light gray inner borders for cells */
        }
        tbody tr {
            background: rgba(240, 240, 240, 0.6); /* Existing style unchanged */
        }
        tbody tr:hover {
            background: rgba(255, 255, 255, 0.6); /* Existing style unchanged */
        }
        thead tr {
            background: #e5e7eb; /* Existing style unchanged */
        }
        thead tr:hover {
            background: #e5e7eb; /* Existing style unchanged */
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen">
<div class="container mx-auto p-8 max-w-5xl mt-8">
    <h1 class="text-2xl font-bold mb-4">Stylist List</h1>
    <table class="w-full max-w-full shadow-md rounded">
        <thead>
        <tr class="bg-gray-200 text-black uppercase text-sm leading-normal">
            <th class="border px-4 py-2">ID</th>
            <th class="border px-4 py-2">Name</th>
            <th class="border px-4 py-2">Specialty</th>
            <th class="border px-4 py-2">Availability</th>
            <th class="border px-4 py-2">Type</th>
            <th class="border px-4 py-2">Actions</th>
        </tr>
        </thead>
        <tbody class="text-black">
        <%
            List<Stylist> stylists = (List<Stylist>) request.getAttribute("stylists");
            if (stylists != null && !stylists.isEmpty()) {
                for (Stylist stylist : stylists) {
        %>
        <tr id="stylist-row-<%= stylist.getId() %>" class="border-b">
            <td class="py-3 px-6"><%= stylist.getId() %></td>
            <td class="py-3 px-6"><%= stylist.getName() %></td>
            <td class="py-3 px-6"><%= stylist.getSpecialty() %></td>
            <td class="py-3 px-6"><%= stylist.getAvailability() %></td>
            <td class="py-3 px-6"><%= stylist.getType() %></td>
            <td class="py-3 px-6">
                <a href="stylist?action=update&id=<%= stylist.getId() %>" class="text-blue-500 hover:underline mr-2">Edit</a>
                <a href="#" class="delete-btn text-red-500 hover:underline" data-id="<%= stylist.getId() %>">Delete</a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="6" class="py-3 px-6 text-center">No stylists available.</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <div class="mt-6 flex space-x-4">
        <a href="stylist?action=register" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">Add New Stylist</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>