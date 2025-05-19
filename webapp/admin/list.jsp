<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.models.Admin" %>
<html>
<head>
    <title>Admin List - BeautySalonSL</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/salon-bg3.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white bg-opacity-80 p-6 rounded-lg shadow-lg">
    <h1 class="text-2xl font-bold mb-4">Admin Management</h1>
    <% if (request.getAttribute("error") != null) { %>
    <p class="text-red-500 mb-4"><%= request.getAttribute("error") %></p>
    <% } %>
    <table class="w-full border">
        <tr class="bg-gray-200">
            <th class="border p-2">ID</th>
            <th class="border p-2">Name</th>
            <th class="border p-2">Email</th>
            <th class="border p-2">Phone</th>
            <th class="border p-2">Username</th>
            <th class="border p-2">Password</th>
            <th class="border p-2">Actions</th>
        </tr>
        <%
            List<Admin> admins = (List<Admin>) request.getAttribute("admins");
            if (admins != null && !admins.isEmpty()) {
                for (Admin admin : admins) {
        %>
        <tr>
            <td class="border p-2"><%= admin.getId() %></td>
            <td class="border p-2"><%= admin.getName() != null ? admin.getName() : "-" %></td>
            <td class="border p-2"><%= admin.getEmail() != null ? admin.getEmail() : "-" %></td>
            <td class="border p-2"><%= admin.getPhone() != null ? admin.getPhone() : "-" %></td>
            <td class="border p-2"><%= admin.getUsername() != null ? admin.getUsername() : "-" %></td>
            <td class="border p-2"><%= admin.getPassword() != null ? admin.getPassword() : "-" %></td>
            <td class="border p-2">
                <a href="admin?action=edit&id=<%= admin.getId() %>" class="text-blue-500">Edit</a>
                <form action="admin" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this admin?');">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= admin.getId() %>">
                    <button type="submit" class="text-red-500">Delete</button>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7" class="border p-2 text-center">No admins found.</td>
        </tr>
        <% } %>
    </table>
    <div class="mt-4 space-x-4">
        <a href="admin?action=add" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Add New Admin</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Home</a>
    </div>
</div>
</body>
</html>