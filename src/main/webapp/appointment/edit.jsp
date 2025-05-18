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
<%@ page import="com.example.models.Appointment" %>
<%@ page import="com.example.handlers.ServiceHandler" %>
<%@ page import="com.example.handlers.StylistHandler" %>
<%@ page import="com.example.models.Service" %>
<%@ page import="com.example.models.Stylist" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<html>
<head>
    <title>Edit Appointment</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
    <script>
        // Time slots
        const timeSlots = [
            "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM",
            "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"
        ];

        function populateTimeSlots(selectedTime) {
            const timeSelect = document.getElementById("time");
            timeSelect.innerHTML = '<option value="" disabled selected>Select a time</option>';
            timeSlots.forEach(slot => {
                const option = document.createElement("option");
                option.value = slot;
                option.text = slot;
                if (slot === selectedTime) {
                    option.selected = true;
                }
                timeSelect.appendChild(option);
            });
        }

        function filterServicesAndStylists() {
            const serviceTypeSelect = document.getElementById("serviceType");
            const serviceSelect = document.getElementById("service");
            const stylistSelect = document.getElementById("stylist");
            const selectedServiceType = serviceTypeSelect.value;

            // Filter services
            const serviceOptions = serviceSelect.querySelectorAll("option[data-type]");
            serviceOptions.forEach(option => {
                option.style.display = (selectedServiceType === "" || option.getAttribute("data-type") === selectedServiceType) ? "" : "none";
                if (option.style.display === "none" && option.selected) {
                    serviceSelect.value = "";
                }
            });

            // Filter stylists
            const stylistOptions = stylistSelect.querySelectorAll("option[data-specialty]");
            stylistOptions.forEach(option => {
                option.style.display = (selectedServiceType === "" || option.getAttribute("data-specialty") === selectedServiceType) ? "" : "none";
                if (option.style.display === "none" && option.selected) {
                    stylistSelect.value = "";
                }
            });
        }

        function updateServiceType() {
            const serviceSelect = document.getElementById("service");
            const serviceTypeSelect = document.getElementById("serviceType");
            const selectedService = serviceSelect.options[serviceSelect.selectedIndex];
            if (selectedService && selectedService.getAttribute("data-type")) {
                serviceTypeSelect.value = selectedService.getAttribute("data-type");
                filterServicesAndStylists();
            }
        }

        window.onload = function() {
            populateTimeSlots('<%= ((Appointment) request.getAttribute("appointment")).getTime() %>');
            filterServicesAndStylists();
            // Set initial service and stylist
            const serviceSelect = document.getElementById("service");
            const currentService = '<%= ((Appointment) request.getAttribute("appointment")).getServiceType().split(" - ").length > 1 ? ((Appointment) request.getAttribute("appointment")).getServiceType().split(" - ")[1] : "" %>';
            if (currentService) {
                serviceSelect.value = currentService;
                updateServiceType();
            }
        };
    </script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg w-full max-w-md">
    <h1 class="text-2xl font-bold mb-4 text-center">Edit Appointment</h1>
    <% 
        Appointment appt = (Appointment) request.getAttribute("appointment"); 
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
        String[] serviceTypeParts = appt.getServiceType().split(" - ");
        String currentServiceType = serviceTypeParts[0];
        String currentService = serviceTypeParts.length > 1 ? serviceTypeParts[1] : "";
    %>
    <form action="appointment" method="post" class="space-y-4">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= appt.getId() %>">
        <input type="hidden" name="customerId" value="<%= appt.getCustomerId() %>">
        
        <div>
            <label class="block text-gray-700 font-semibold mb-1">Service Type</label>
            <select name="serviceType" id="serviceType" required class="border p-2 w-full rounded" onchange="filterServicesAndStylists()">
                <option value="" disabled <%= currentServiceType.isEmpty() ? "selected" : "" %>>Select a service type</option>
                <% for (String type : serviceTypes) { %>
                    <option value="<%= type %>" <%= type.equals(currentServiceType) ? "selected" : "" %>><%= type %></option>
                <% } %>
            </select>
        </div>
        
        <div>
            <label class="block text-gray-700 font-semibold mb-1">Service</label>
            <select name="service" id="service" required class="border p-2 w-full rounded" onchange="updateServiceType()">
                <option value="" disabled <%= currentService.isEmpty() ? "selected" : "" %>>Select a service</option>
                <% if (services != null) { %>
                    <% for (Service service : services) { %>
                        <option value="<%= service.getName() %>" data-type="<%= service.getType() %>" <%= service.getName().equals(currentService) ? "selected" : "" %>><%= service.getName() %></option>
                    <% } %>
                <% } %>
            </select>
        </div>
        
        <div>
            <label class="block text-gray-700 font-semibold mb-1">Date</label>
            <input type="date" name="date" value="<%= appt.getDate() %>" required class="border p-2 w-full rounded">
        </div>
        
        <div>
            <label class="block text-gray-700 font-semibold mb-1">Time</label>
            <select id="time" name="time" required class="border p-2 w-full rounded">
                <!-- Populated dynamically by JavaScript -->
            </select>
        </div>
        
        <div>
            <label class="block text-gray-700 font-semibold mb-1">Stylist</label>
            <select name="stylist" id="stylist" required class="border p-2 w-full rounded">
                <option value="" disabled <%= appt.getStylist().isEmpty() ? "selected" : "" %>>Select a stylist</option>
                <% if (stylists != null) { %>
                    <% for (Stylist stylist : stylists) { %>
                        <option value="<%= stylist.getName() %>" data-specialty="<%= stylist.getSpecialty() %>" <%= stylist.getName().equals(appt.getStylist()) ? "selected" : "" %>><%= stylist.getName() %></option>
                    <% } %>
                <% } %>
            </select>
        </div>
        
        <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 w-full">Update</button>
    </form>
    <a href="appointment?action=list" class="text-blue-500 mt-4 inline-block hover:underline">Back to Appointment List</a>
</div>
</body>
</html>