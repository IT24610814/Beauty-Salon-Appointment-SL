
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.models.Customer" %>
<html>
<head>
    <title>Register Customer</title>
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
    <h1 class="text-2xl font-bold mb-4">Register New Customer</h1>
    <form action="customer" method="post" class="space-y-4">
        <input type="hidden" name="action" value="register">
        <div><label>ID:</label><input type="number" name="id" required class="border p-2 w-full"></div>
        <div><label>Name:</label><input type="text" name="name" required class="border p-2 w-full"></div>
        <div><label>Email:</label><input type="email" name="email" required class="border p-2 w-full"></div>
        <div><label>Phone:</label><input type="text" name="phone" required class="border p-2 w-full"></div>
        <div><label>Preferred Stylist:</label><input type="text" name="preferredStylist" class="border p-2 w-full"></div>
        <div><label>Type:</label><select name="type" class="border p-2 w-full"><option value="Regular">Regular</option><option value="VIP">VIP</option></select></div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Register</button>
    </form>
    <a href="customer?action=list" class="text-blue-500 mt-4 inline-block">Back to Customer List</a>
</div>
</body>
</html>                
   
