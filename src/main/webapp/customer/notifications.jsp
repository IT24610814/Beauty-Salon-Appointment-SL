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
<!DOCTYPE html>
<html>
<head>
    <title>Notifications - Beauty Salon Sri Lanka</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
    </style>
</head>
<body class="min-h-screen bg-gray-100 flex flex-col items-center">
<div class="bg-white bg-opacity-80 p-8 rounded-lg shadow-lg w-full max-w-5xl mt-8">
    <h1 class="text-3xl font-bold text-center mb-6 text-gray-800">Notifications</h1>

    <!-- Notifications Table -->
    <table class="w-full border border-gray-300">
        <thead>
        <tr class="bg-gray-200">
            <th class="border px-4 py-2">Request</th>
            <th class="border px-4 py-2">Action</th>
        </tr>
        </thead>
        <tbody>
        <!-- Placeholder Data -->
        <tr>
            <td class="border px-4 py-2">Appointment Request from Jane Doe on May 20, 2025</td>
            <td class="border px-4 py-2">
                <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 mr-2">Accept</button>
                <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Delete</button>
            </td>
        </tr>
        <tr>
            <td class="border px-4 py-2">VIP Service Upgrade Request from John Smith</td>
            <td class="border px-4 py-2">
                <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 mr-2">Accept</button>
                <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Delete</button>
            </td>
        </tr>
        </tbody>
    </table>

    <div class="mt-6 flex justify-center">
        <a href="customer?action=list" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Customer List</a>
    </div>
</div>
</body>
</html>