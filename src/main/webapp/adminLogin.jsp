<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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