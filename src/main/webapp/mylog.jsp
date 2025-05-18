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
    <title>My Appointments - BeautySalonSL</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .btn-primary {
            background-color: #ff4d6d;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn-primary:hover {
            background-color: #ff6f89;
        }
        .btn-secondary {
            background-color: #6b7280;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn-secondary:hover {
            background-color: #9ca3af;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white shadow rounded-lg p-8 max-w-md mx-auto text-center">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">My Appointments</h1>
        <form action="#" method="post" class="space-y-6">
            <div>
                <label for="phone" class="block text-gray-700 font-medium mb-2">Enter Your Phone Number</label>
                <input type="tel" id="phone" name="phone" maxlength="10" pattern="[0-9]{10}" required
                       class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-600"
                       placeholder="1234567890">
            </div>
            <button type="submit" class="btn-primary w-full">Login</button>
        </form>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/mainIndex.jsp" class="btn-secondary">Back</a>
        </div>
    </div>
</body>
</html>