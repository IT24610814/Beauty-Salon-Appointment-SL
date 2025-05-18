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
        </script><script type="text/javascript">
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
<%@ page import="java.util.List, java.util.Set, java.util.HashSet, com.example.models.Service, com.example.handlers.ServiceHandler, com.example.models.Stylist, com.example.handlers.StylistHandler, jakarta.servlet.ServletContext" %>
<html>
<head>
    <title>Book an Appointment</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg2.jpg');
            background-size: cover;
            background-position: center;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .form-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }
        .form-box {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 0.5rem;
            padding: 2rem;
            width: 100%;
            max-width: 500px;
            height: 500px;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-scrollable {
            flex: 1;
            overflow-y: auto;
            padding-right: 0.5rem;
        }
        .form-buttons {
            margin-top: 1rem;
        }
        .btn-primary {
            background-color: #d63384;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.375rem;
            text-decoration: none;
            display: inline-block;
            width: 100%;
            text-align: center;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
<%
    ServletContext context = pageContext.getServletContext();
    ServiceHandler serviceHandler = new ServiceHandler(context);
    StylistHandler stylistHandler = new StylistHandler(context);
    List<Service> services = serviceHandler.getAllServices();
    List<Stylist> stylists = stylistHandler.getAllStylists();
    Set<String> serviceTypes = new HashSet<>();
    if (services != null) {
        for (Service service : services) {
            serviceTypes.add(service.getType());
        }
    }
%>
<div class="form-container">
    <div class="form-box">
        <div class="form-scrollable">
            <h2 class="text-3xl font-bold text-gray-800 mb-6 text-center">Book an Appointment</h2>
            <form id="appointmentForm" action="${pageContext.request.contextPath}/appointment" method="post" class="space-y-4">
                <input type="hidden" name="action" value="book">
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Name</label>
                    <input type="text" name="name" placeholder="Your name" required class="border p-2 w-full rounded">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Email</label>
                    <input type="email" name="email" placeholder="your.email@example.com" required class="border p-2 w-full rounded">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Phone Number</label>
                    <input type="tel" name="phone" placeholder="Your phone number" required class="border p-2 w-full rounded">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Service Type</label>
                    <select name="serviceType" id="serviceType" required class="border p-2 w-full rounded" onchange="filterServicesAndStylists()">
                        <option value="" disabled selected>Select a service type</option>
                        <% for (String type : serviceTypes) { %>
                        <option value="<%= type %>"><%= type %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Service</label>
                    <select name="service" id="service" required class="border p-2 w-full rounded" onchange="updateServiceType()">
                        <option value="" disabled selected>Select a service</option>
                        <% if (services != null) { %>
                        <% for (Service service : services) { %>
                        <option value="<%= service.getName() %>" data-type="<%= service.getType() %>"><%= service.getName() %></option>
                        <% } %>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Date</label>
                    <input type="date" name="date" required class="border p-2 w-full rounded">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Time</label>
                    <select name="time" required class="border p-2 w-full rounded">
                        <option value="" disabled selected>Select a time</option>
                        <%
                            String[] times = {"8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM"};
                            for (String time : times) {
                        %>
                        <option value="<%= time %>"><%= time %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-1">Stylist</label>
                    <select name="stylist" id="stylist" required class="border p-2 w-full rounded">
                        <option value="" disabled selected>Select a stylist</option>
                        <% if (stylists != null) { %>
                        <% for (Stylist stylist : stylists) { %>
                        <option value="<%= stylist.getName() %>" data-specialty="<%= stylist.getSpecialty() %>"><%= stylist.getName() %></option>
                        <% } %>
                        <% } %>
                    </select>
                </div>
            </form>
        </div>
        <div class="form-buttons">
            <button type="submit" form="appointmentForm" class="bg-blue-500 text-white p-2 rounded w-full">Book Appointment</button>
            <a href="${pageContext.request.contextPath}/appointment?action=list" class="text-blue-500 mt-2 text-center block">Back to Appointment List</a>
        </div>
    </div>
</div>
<script>
    function filterServicesAndStylists() {
        const serviceType = document.getElementById('serviceType').value;
        const serviceSelect = document.getElementById('service');
        const stylistSelect = document.getElementById('stylist');
        const serviceOptions = serviceSelect.querySelectorAll('option');
        const stylistOptions = stylistSelect.querySelectorAll('option');

        // Filter services
        serviceOptions.forEach(option => {
            if (option.value === "") {
                return; // Skip the placeholder option
            }
            const type = option.getAttribute('data-type');
            if (type === serviceType) {
                option.style.display = 'block';
            } else {
                option.style.display = 'none';
            }
        });

        // Filter stylists based on specialty matching service type
        stylistOptions.forEach(option => {
            if (option.value === "") {
                return; // Skip the placeholder option
            }
            const specialty = option.getAttribute('data-specialty');
            if (specialty === serviceType) {
                option.style.display = 'block';
            } else {
                option.style.display = 'none';
            }
        });
        stylistSelect.value = "";
    }

    function updateServiceType() {
        const serviceSelect = document.getElementById('service');
        const serviceTypeSelect = document.getElementById('serviceType');
        const selectedService = serviceSelect.options[serviceSelect.selectedIndex];

        if (selectedService.value !== "") {
            const serviceType = selectedService.getAttribute('data-type');
            serviceTypeSelect.value = serviceType;
            filterServicesAndStylists(); // Update services and stylists based on new service type
        }
    }

    // Autofill from URL parameters
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const serviceType = urlParams.get('serviceType');
        const service = urlParams.get('service');

        if (serviceType && service) {
            document.getElementById('serviceType').value = serviceType;
            filterServicesAndStylists(); // Update services and stylists
            const serviceSelect = document.getElementById('service');
            serviceSelect.value = service;
        }
    }
</script>
</body>
</html>