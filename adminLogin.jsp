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
<html>
<head>
    <title>Beauty Salon Sri Lanka - Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg1.jpg');
            background-size: cover;
            background-position: center;
            transition: background-image 1s ease;
        }
        .bg-rotate { animation: bgRotate 15s infinite; }
        @keyframes bgRotate {
            0% { background-image: url('${pageContext.request.contextPath}/images/salon-bg1.jpg'); }
            20% { background-image: url('${pageContext.request.contextPath}/images/salon-bg2.jpg'); }
            40% { background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg'); }
            60% { background-image: url('${pageContext.request.contextPath}/images/salon-bg4.jpg'); }
            80% { background-image: url('${pageContext.request.contextPath}/images/salon-bg5.jpg'); }
            100% { background-image: url('${pageContext.request.contextPath}/images/salon-bg6.jpg'); }
        }
    </style>
    <script>
        function rotateBackground() {
            document.body.classList.add('bg-rotate');
        }
        window.onload = rotateBackground;
    </script>
</head>
<body class="min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg text-center">
    <h1 class="text-4xl font-bold mb-4 text-gray-800">Admin Login</h1>
    <p class="text-lg mb-6">Enter your admin credentials</p>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="${pageContext.request.contextPath}/admin-login" method="post" class="space-y-4">
        <div>
            <input type="text" name="username" placeholder="Username" required
                   class="w-full px-4 py-2 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
            <input type="password" name="password" placeholder="Password" required
                   class="w-full px-4 py-2 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Login</button>
    </form>
</div>
</body>
</html>