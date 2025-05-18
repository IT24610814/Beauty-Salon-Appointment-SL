<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.models.Customer" %>
<html>
<head>
    <title>Update Customer</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg2.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg">
    <h1 class="text-2xl font-bold mb-4">Update Customer</h1>
    <% Customer customer = (Customer) request.getAttribute("customer"); %>
    <form action="customer" method="post" class="space-y-4">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= customer.getId() %>">
        <div><label>Name:</label><input type="text" name="name" value="<%= customer.getName() %>" required class="border p-2 w-full"></div>
        <div><label>Email:</label><input type="email" name="email" value="<%= customer.getEmail() %>" required class="border p-2 w-full"></div>
        <div><label>Phone:</label><input type="text" name="phone" value="<%= customer.getPhone() %>" required class="border p-2 w-full"></div>
        <div><label>Preferred Stylist:</label><input type="text" name="preferredStylist" value="<%= customer.getPreferredStylist() %>" class="border p-2 w-full"></div>
        <div><label>Type:</label>
            <select name="type" class="border p-2 w-full">
                <option value="Regular" <%= "Regular".equals(customer.getType()) ? "selected" : "" %>>Regular</option>
                <option value="VIP" <%= "VIP".equals(customer.getType()) ? "selected" : "" %>>VIP</option>
            </select>
        </div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Update</button>
    </form>
    <a href="customer?action=list" class="text-blue-500 mt-4 inline-block">Back to Customer List</a>
</div>
</body>
</html>               
