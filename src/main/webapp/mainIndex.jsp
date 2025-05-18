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
<%@ page import="java.util.List, com.example.models.Service, com.example.handlers.ServiceHandler, com.example.models.Feedback, com.example.handlers.FeedbackHandler, jakarta.servlet.ServletContext, com.example.models.Stylist, com.example.handlers.StylistHandler" %>
<html>
<head>
    <title>Beauty Salon Sri Lanka</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: url('https://www.toptal.com/designers/subtlepatterns/uploads/double-bubble-outline.png');
            background-size: cover;
            background-position: center;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            background-color: #f8f9fa;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }
        .nav-links {
            display: flex;
            align-items: center;
        }
        .nav-link {
            color: #6b7280;
            margin: 0 1rem;
            text-decoration: none;
            font-size: 1.1rem;
        }
        .nav-link.active {
            color: #d63384;
            font-weight: bold;
        }
        .logo {
            color: #d63384;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            margin-right: 2rem;
        }
        .hero {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 2rem;
            padding-top: 80px;
        }
        .services {
            min-height: 80vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 2rem;
            padding-top: 80px;
        }
        #home {
            scroll-margin-top: 80px;
        }
        #services {
            scroll-margin-top: 80px;
        }
        #about-our-salon {
            scroll-margin-top: 100px;
        }
        #testimonials {
            scroll-margin-top: 100px;
            padding-bottom: 20rem;
        }
        #contact-us {
            scroll-margin-top: 80px;
        }
        .service-card {
            background: white;
            border-radius: 0.5rem;
            padding: 1.5rem;
            width: 300px;
            margin: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: none;
        }
        .service-card.show {
            display: block;
        }
        .team-card {
            background: white;
            border-radius: 0.5rem;
            padding: 1.5rem;
            width: 250px;
            margin: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .choice-card, .value-card, .testimonial-card, .contact-card {
            background: white;
            border-radius: 0.5rem;
            padding: 1.5rem;
            width: 300px;
            margin: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .btn-primary {
            background-color: #d63384;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.375rem;
            text-decoration: none;
            display: inline-block;
        }
        .button-group {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        .filter-buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .filter-btn {
            background-color: #e5e7eb;
            color: #374151;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            text-decoration: none;
            cursor: pointer;
        }
        .filter-btn.active {
            background-color: #d63384;
            color: white;
        }
        .star {
            font-size: 24px;
            cursor: default; /* Changed from pointer to default */
            color: #ccc;
        }
        .star.filled {
            color: #ffd700;
        }
        .testimonial-star {
            pointer-events: none; /* Disable click events for testimonial stars */
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
<%
    // Initialize StylistHandler and fetch stylists
    StylistHandler stylistHandler = new StylistHandler(pageContext.getServletContext());
    List<Stylist> stylists = stylistHandler.getAllStylists();
%>
<nav class="navbar flex justify-between items-center">
    <a href="${pageContext.request.contextPath}/mainIndex.jsp" class="logo">BeautySalon</a>
    <div class="flex flex-col items-end">
        <div class="nav-links">
            <a href="#home" class="nav-link active">Home</a>
            <a href="#services" class="nav-link">Services</a>
            <a href="#about-our-salon" class="nav-link">About</a>
            <a href="#testimonials" class="nav-link">Reviews</a>
            <a href="#contact-us" class="nav-link">Contact</a>
            <a href="${pageContext.request.contextPath}/bookAppointment.jsp" class="btn-primary">Book Now</a>
        </div>
        <a href="${pageContext.request.contextPath}/adminLogin.jsp" class="btn-primary mt-2">Admin Login</a>
    </div>
</nav>
<div id="home" class="hero">
    <h1 class="text-5xl font-bold text-gray-800 mb-4">Beauty Salon & Spa</h1>
    <p class="text-lg text-gray-600 mb-6">Experience the ultimate relaxation and beauty treatments at our premium salon.</p>
    <div class="button-group">
        <a href="#services" class="btn-primary">Our Services</a>
        <a href="${pageContext.request.contextPath}/bookAppointment.jsp" class="btn-primary">Book Appointment</a>
    </div>
</div>
<div id="services" class="services">
    <h2 class="text-4xl font-bold text-gray-800 mb-6">Our Services</h2>
    <p class="text-lg text-gray-600 mb-8">Discover our comprehensive range of beauty and wellness services designed to enhance your natural beauty and provide a relaxing experience.</p>
    <div class="filter-buttons">
        <button class="filter-btn active" data-filter="all">All Services</button>
        <button class="filter-btn" data-filter="hair">Hair Care</button>
        <button class="filter-btn" data-filter="face">Facial Care</button>
        <button class="filter-btn" data-filter="manicure">Manicure Services</button>
        <button class="filter-btn" data-filter="pedicure">Pedicure Services</button>
        <button class="filter-btn" data-filter="vip">VIP Services</button>
    </div>
    <div class="flex flex-wrap justify-center">
        <%
            try {
                ServletContext context = pageContext.getServletContext();
                ServiceHandler serviceHandler = new ServiceHandler(context);
                List<Service> services = serviceHandler.getAllServices();
                if (services != null && !services.isEmpty()) {
                    for (Service service : services) {
                        String cardClass = "service-card ";
                        switch (service.getType()) {
                            case "Hair Care":
                                cardClass += "hair";
                                break;
                            case "Facial Care":
                                cardClass += "face";
                                break;
                            case "Manicure Services":
                                cardClass += "manicure";
                                break;
                            case "Pedicure Services":
                                cardClass += "pedicure";
                                break;
                            case "VIP Services":
                                cardClass += "vip";
                                break;
                        }
        %>
        <div class="<%= cardClass %> show">
            <h3 class="text-xl font-semibold text-gray-800 mb-2"><%= service.getName() %></h3>
            <p class="text-gray-600 mb-2"><%= service.getDescription() != null ? service.getDescription() : "No description available" %></p>
            <p class="text-gray-600">From <%= String.format("%.2f", service.getPrice()) %> (LKR) | <%= service.getDuration() %> min</p>
            <a href="${pageContext.request.contextPath}/bookAppointment.jsp?serviceType=<%= java.net.URLEncoder.encode(service.getType(), "UTF-8") %>&service=<%= java.net.URLEncoder.encode(service.getName(), "UTF-8") %>" class="btn-primary mt-4">Book Now</a>
        </div>
        <%
            }
        } else {
        %>
        <p class="text-gray-600">No services available at the moment.</p>
        <%
            }
        } catch (Exception e) {
        %>
        <p class="text-red-500">Error loading services: <%= e.getMessage() %></p>
        <%
            }
        %>
    </div>
    <div id="about-our-salon">
        <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">About Our Salon</h2>
        <p class="text-lg text-gray-600 mb-8 text-center">Providing exceptional beauty services with a personal touch since 2010.</p>
        <div class="flex flex-col items-center">
            <h3 class="text-2xl font-semibold text-gray-800 mb-4">Our Story</h3>
            <p class="text-lg text-gray-600 mb-6 max-w-2xl text-center">Beauty Salon was founded with a simple mission to provide exceptional beauty services in a welcoming and relaxing environment. What started as a small studio has grown into a full-service salon with a team of dedicated professionals. We believe that everyone deserves to feel beautiful and confident. Our team of skilled stylists, aestheticians, and massage therapists are committed to helping you look and feel your best.</p>
        </div>
    </div>
    <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Meet Our Team</h2>
    <div class="flex flex-wrap justify-center">
        <% if (stylists != null && !stylists.isEmpty()) { %>
        <% for (Stylist stylist : stylists) { %>
        <div class="team-card">
            <img src="${pageContext.request.contextPath}/<%= stylist.getImagePath() != null ? stylist.getImagePath() : "images/default.jpg" %>" alt="<%= stylist.getName() %>" class="w-full h-48 object-cover mb-4" onerror="this.src='${pageContext.request.contextPath}/images/default.jpg';">
            <h3 class="text-xl font-semibold text-gray-800"><%= stylist.getName() %></h3>
            <p class="text-gray-600"><%= stylist.getSpecialty() %> Stylist</p>
        </div>
        <% } %>
        <% } else { %>
        <p class="text-gray-600">No team members available at the moment.</p>
        <% } %>
    </div>
    <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Our Values</h2>
    <div class="flex flex-wrap justify-center">
        <div class="value-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Quality</h3>
            <p class="text-gray-600">We use premium products and continuously train our staff to provide the highest services.</p>
        </div>
        <div class="value-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Integrity</h3>
            <p class="text-gray-600">We treat each client with respect and honesty, providing transparent pricing and honest recommendations.</p>
        </div>
        <div class="value-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Innovation</h3>
            <p class="text-gray-600">We stay current with industry trends and continuously expand our knowledge and techniques.</p>
        </div>
    </div>
    <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Ready to Experience Our Services?</h2>
    <p class="text-lg text-gray-600 mb-6 text-center">Book an appointment today and discover why our clients keep coming back.</p>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/bookAppointment.jsp" class="btn-primary">Book an Appointment</a>
    </div>
    <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Why Choose Us</h2>
    <div class="flex flex-wrap justify-center">
        <div class="choice-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Expert Stylists</h3>
            <p class="text-gray-600">Our team of professionals is trained in the latest techniques and trends.</p>
        </div>
        <div class="choice-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Premium Products</h3>
            <p class="text-gray-600">We use only high-quality products that are gentle on your hair and skin.</p>
        </div>
        <div class="choice-card">
            <h3 class="text-xl font-semibold text-gray-800 mb-2">Relaxing Atmosphere</h3>
            <p class="text-gray-600">Enjoy a peaceful environment designed for your comfort and relaxation.</p>
        </div>
    </div>
    <div id="testimonials">
        <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Testimonials</h2>
        <div class="flex flex-wrap justify-center">
            <%
                try {
                    ServletContext context = pageContext.getServletContext();
                    FeedbackHandler feedbackHandler = new FeedbackHandler(context);
                    List<Feedback> feedbackList = feedbackHandler.getAllFeedbacks();
                    if (feedbackList != null && !feedbackList.isEmpty()) {
                        for (Feedback feedback : feedbackList) {
                            int rating = feedback.getRating();
            %>
            <div class="testimonial-card">
                <h3 class="text-xl font-semibold text-gray-800 mb-2"><%= feedback.getCustomerName() %></h3>
                <div class="flex mb-2">
                    <% for (int i = 1; i <= 5; i++) { %>
                    <span class="star testimonial-star <%= i <= rating ? "filled" : "" %>">★</span>
                    <% } %>
                </div>
                <p class="text-gray-600 italic">"<%= feedback.getComments() %>"</p>
            </div>
            <%
                }
            } else {
            %>
            <p class="text-gray-600">No testimonials available at the moment.</p>
            <%
                }
            } catch (Exception e) {
        %>
        <p class="text-red-500">Error loading testimonials: <%= e.getMessage() %></p>
        <%
            }
        %>
        </div>
    </div>
    <div id="send-feedback">
        <a href="mfeedback.jsp" class="bg-indigo-500 text-white px-4 py-2 rounded hover:bg-indigo-600">Send Feedback</a>
    </div>
    <div id="contact-us" class="services">
        <h2 class="text-4xl font-bold text-gray-800 mb-6 mt-12">Contact Us</h2>
        <p class="text-lg text-gray-600 mb-8 text-center">Have questions or want to book an appointment? Reach out to us.</p>
        <div class="flex flex-wrap justify-center">
            <div class="contact-card">
                <h3 class="text-xl font-semibold text-gray-800 mb-2">Our Location</h3>
                <p class="text-gray-600">123 Beauty Street<br>City, State 12345</p>
            </div>
            <div class="contact-card">
                <h3 class="text-xl font-semibold text-gray-800 mb-2">Phone Number</h3>
                <p class="text-gray-600">Main: (123) 456-7890<br>Support: (123) 456-7891</p>
            </div>
            <div class="contact-card">
                <h3 class="text-xl font-semibold text-gray-800 mb-2">Business Hours</h3>
                <p class="text-gray-600">Monday-Friday: 9AM-7PM<br>Saturday: 9AM-5PM<br>Sunday: Closed</p>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const filterButtons = document.querySelectorAll('.filter-btn');
        const serviceCards = document.querySelectorAll('.service-card');

        filterButtons.forEach(button => {
            button.addEventListener('click', () => {
                filterButtons.forEach(btn => btn.classList.remove('active'));
                button.classList.add('active');

                const filter = button.getAttribute('data-filter');

                serviceCards.forEach(card => {
                    if (filter === 'all') {
                        card.classList.add('show');
                    } else {
                        if (card.classList.contains(filter)) {
                            card.classList.add('show');
                        } else {
                            card.classList.remove('show');
                        }
                    }
                });
            });
        });

        document.querySelector('a[href="#services"]').addEventListener('click', () => {
            document.querySelector('.filter-btn[data-filter="all"]').click();
        });

        // Star rating logic for Send Feedback form
        const stars = document.querySelectorAll('#starRating .star');
        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = parseInt(star.getAttribute('data-value'));
                console.log('Star clicked with value:', value); // Debug log
                stars.forEach((s, index) => {
                    if (index < value) {
                        s.classList.add('filled');
                        console.log('Adding filled to star', index + 1); // Debug log
                    } else {
                        s.classList.remove('filled');
                        console.log('Removing filled from star', index + 1); // Debug log
                    }
                });
                document.getElementById('ratingInput').value = value;
                console.log('Rating input set to:', value); // Debug log
            });
        });
    });
</script>
</body>
</html>