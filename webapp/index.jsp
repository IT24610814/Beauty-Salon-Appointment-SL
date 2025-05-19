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
    <title>Beauty Salon Sri Lanka</title>
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

        function confirmQuit() {
            console.log("Quit button clicked");
            if (confirm("Do you want to quit from this page?")) {
                console.log("Redirecting to mainIndex.jsp");
                window.location.href = "${pageContext.request.contextPath}/mainIndex.jsp";
            } else {
                console.log("User canceled quit");
            }
        }
    </script>
</head>
<body class="min-h-screen flex items-center justify-center">
<%
    if (session.getAttribute("loggedInAdmin") == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
    }
%>
<div class="flex flex-col items-center w-3/4">
    <div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg text-center w-full">
        <h1 class="text-4xl font-bold mb-4 text-gray-800">Welcome, <%= session.getAttribute("loggedInAdmin") %>!</h1>
        <p class="text-lg mb-6">Your premier beauty destination in Sri Lanka!</p>
        <div class="space-x-4">
            <a href="customer?action=list" class="bg-blue-500 text-white px-4 py-2 rounded">Customer Management</a>
            <a href="appointment?action=list" class="bg-green-500 text-white px-4 py-2 rounded">Book Appointment</a>
            <a href="service?action=list" class="bg-purple-500 text-white px-4 py-2 rounded">View Services</a>
            <a href="${pageContext.request.contextPath}/stylist?action=list" class="bg-yellow-500 text-white px-4 py-2 rounded">Stylist Info</a>
            <a href="${pageContext.request.contextPath}/feedback?action=display" class="bg-indigo-500 text-white px-4 py-2 rounded" onclick="console.log('Navigating to feedback display')">Submit Feedback</a>
            <a href="${pageContext.request.contextPath}/admin?action=list" class="bg-red-500 text-white px-4 py-2 rounded">Admin Management</a>
        </div>
    </div>
    <div class="self-end mt-6">
        <button onclick="confirmQuit()" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Quit</button>
    </div>
</div>
</body>
</html>