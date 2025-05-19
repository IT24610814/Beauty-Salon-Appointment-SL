<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.models.Admin" %>
<html>
<head>
    <title>Edit Admin - BeautySalonSL</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>body { background-image: url('${pageContext.request.contextPath}/images/salon-bg2.jpg'); background-size: cover; background-position: center; }</style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg">
    <h1 class="text-2xl font-bold mb-4">Edit Admin</h1>
    <%
        Admin admin = (Admin) request.getAttribute("admin");
        if (admin == null) {
    %>
    <p class="text-red-500 mb-4">Admin not found.</p>
    <a href="admin?action=list" class="text-blue-500 mt-4 inline-block">Back to Admin List</a>
    <% } else { %>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="admin" method="post" class="space-y-4">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="id" value="<%= admin.getId() %>">
        <div>
            <label class="block text-gray-700">Name</label>
            <input type="text" name="name" value="<%= admin.getName() != null ? admin.getName() : "" %>" required class="w-full border p-2 rounded">
        </div>
        <div>
            <label class="block text-gray-700">Email</label>
            <input type="email" name="email" value="<%= admin.getEmail() != null ? admin.getEmail() : "" %>" required class="w-full border p-2 rounded">
        </div>
        <div>
            <label class="block text-gray-700">Phone</label>
            <input type="text" name="phone" value="<%= admin.getPhone() != null ? admin.getPhone() : "" %>" required class="w-full border p-2 rounded">
        </div>
        <div>
            <label class="block text-gray-700">Username</label>
            <input type="text" name="username" value="<%= admin.getUsername() != null ? admin.getUsername() : "" %>" required class="w-full border p-2 rounded">
        </div>
        <div>
            <label class="block text-gray-700">Password</label>
            <input type="password" name="password" value="<%= admin.getPassword() != null ? admin.getPassword() : "" %>" required class="w-full border p-2 rounded">
        </div>
        <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Update Admin</button>
    </form>
    <a href="admin?action=list" class="text-blue-500 mt-4 inline-block">Back to Admin List</a>
    <% } %>
</div>
</body>
</html>