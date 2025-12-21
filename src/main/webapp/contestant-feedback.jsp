<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Check if the user is logged in as a judge
    String userName = (String) session.getAttribute("user_name");
    String judgeId = (String) session.getAttribute("user_id");

    if (userName == null || judgeId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Feedback Submission Logic (Server Side) ---
    String message = null;
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String contestantIdStr = request.getParameter("contestantId");
        String ratingStr = request.getParameter("rating");
        String feedbackText = request.getParameter("feedbackText");

        if (contestantIdStr != null && ratingStr != null && feedbackText != null && !contestantIdStr.isEmpty()) {
            try {
                String contestantId = contestantIdStr;
                int rating = Integer.parseInt(ratingStr);

                // Re-create the mock map to get the name for the success message
                Map<String, String> tempContestants = new LinkedHashMap<>();
                tempContestants.put("P101", "Emma Watson");
                tempContestants.put("P102", "Tom Holland");
                tempContestants.put("P103", "Sophia Turner");
                tempContestants.put("P104", "Chris Evans");

                String submittedName = tempContestants.getOrDefault(contestantId, "Contestant");

                message = "Feedback successfully submitted for " + submittedName +
                        " with a " + rating + " star rating.";

            } catch (NumberFormatException e) {
                error = "Invalid Contestant ID or Rating format.";
            } catch (Exception e) {
                error = "An unexpected error occurred during submission.";
                e.printStackTrace();
            }
        } else {
            error = "Please select a contestant, a rating, and provide feedback text.";
        }
    }

    // --- Contestant Data (Mock Data) ---
    Map<String, String> contestants = new LinkedHashMap<>();
    contestants.put("P101", "Emma Watson");
    contestants.put("P102", "Tom Holland");
    contestants.put("P103", "Sophia Turner");
    contestants.put("P104", "Chris Evans");

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Feedback - <%= userName %></title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* --- Base Styles (Charm Theme) --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Montserrat', sans-serif; }
        body {
            /* Soft, engaging background with a subtle gradient/texture */
            background: linear-gradient(135deg, #fce0e8, #f5d4e3);
            color: #4a4a4a;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* --- Header & Navigation (Elegant Dark) --- */
        .header {
            background: linear-gradient(135deg, #4b0082, #6a5acd); /* Deep Purple/Lavender */
            color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .header h1 {
            font-family: 'Playfair Display', serif; /* Elegant heading font */
            font-size: 2.5rem;
            font-weight: 800;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }

        .navbar {
            background-color: rgba(255, 255, 255, 0.9); /* Slightly transparent white */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            padding: 0 2rem;
            border-bottom: 2px solid #ddd;
        }
        .navbar ul { display: flex; list-style: none; }
        .navbar a {
            display: block;
            padding: 1rem 1.5rem;
            text-decoration: none;
            color: #6a5acd; /* Lavender text */
            font-weight: 600;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }
        .navbar a:hover {
            background-color: #f0e6fa; /* Light purple hover */
            color: #4b0082;
            border-bottom: 3px solid #ff69b4; /* Hot Pink Accent */
        }

        .container { max-width: 850px; margin: 3rem auto; padding: 0 1.5rem; }

        /* --- FEEDBACK FORM STYLES (Glassmorphism Charm) --- */
        .feedback-card {
            background: rgba(255, 255, 255, 0.5); /* Semi-transparent background */
            backdrop-filter: blur(10px); /* Glass effect */
            -webkit-backdrop-filter: blur(10px);
            padding: 4rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.4);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s;
        }
        .feedback-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
        }
        .feedback-card h2 {
            font-family: 'Playfair Display', serif;
            color: #4b0082; /* Deep Purple */
            text-align: center;
            margin-bottom: 2.5rem;
            border-bottom: 3px solid #ff69b4; /* Hot Pink underline */
            padding-bottom: 0.8rem;
            font-size: 2.2rem;
        }

        /* Form Controls */
        label {
            display: block;
            margin-bottom: 0.8rem;
            font-weight: 700;
            color: #6a5acd;
            font-size: 1.1rem;
        }

        select, textarea {
            width: 100%;
            padding: 14px;
            margin-bottom: 2rem;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            background-color: rgba(255, 255, 255, 0.7);
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        select:focus, textarea:focus {
            border-color: #ff69b4;
            outline: none;
            box-shadow: 0 0 10px rgba(255, 105, 180, 0.5);
        }

        textarea {
            min-height: 180px;
        }

        /* Submit Button */
        .submit-btn {
            display: block;
            width: 100%;
            padding: 18px;
            /* Elegant Gradient */
            background: linear-gradient(90deg, #ff69b4, #8a2be2); /* Pink to Blue-Violet */
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.3rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4);
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background: linear-gradient(90deg, #8a2be2, #ff69b4);
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 10px 30px rgba(138, 43, 226, 0.6);
        }

        /* --- STAR RATING STYLES --- */
        .rating {
            display: flex;
            justify-content: center;
            flex-direction: row-reverse;
            margin-bottom: 2.5rem;
            gap: 5px;
        }

        .rating input { display: none; }

        .rating label {
            font-size: 3rem;
            color: #ddd;
            cursor: pointer;
            padding: 0 0.1rem;
            transition: color 0.3s ease, text-shadow 0.3s ease;
        }

        /* Highlight stars when hovering */
        .rating label:hover,
        .rating label:hover ~ label {
            color: #ffd700; /* Gold */
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.8);
        }

        /* Highlight selected rating and previous stars */
        .rating input:checked ~ label {
            color: #ffd700;
            text-shadow: 0 0 15px rgba(255, 215, 0, 1);
        }

        /* Message Boxes */
        .message-box {
            padding: 18px;
            margin-bottom: 2rem;
            border-radius: 10px;
            font-weight: 600;
            text-align: center;
            font-size: 1.1rem;
        }
        .success {
            background-color: #e6ffe6;
            color: #2ecc71;
            border: 1px solid #2ecc71;
        }
        .error {
            background-color: #ffe6e6;
            color: #e74c3c;
            border: 1px solid #e74c3c;
        }

        @media (max-width: 768px) {
            .feedback-card { padding: 1.5rem; }
            .navbar ul { flex-direction: column; }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Judge Voting Portal</h1>
</div>

<div class="navbar">
    <ul>
        <li><a href="judge-dashboard.jsp">Dashboard</a></li>
        <li><a href="contestant-performance.jsp">View Performance</a></li>
        <li><a href="view-scores.jsp">Scoreboard</a></li>
        <li><a href="contestant-profiles.jsp">Contestants</a></li>
        <li><a href="voter-dashboard.jsp">Account</a></li>
        <li><a href="index.jsp">Logout</a></li>
    </ul>
</div>

<div class="container">
    <div class="feedback-card">
        <h2>Submit Contestant Feedback 📝</h2>

        <% if (message != null) { %>
        <div class="message-box success"><%= message %></div>
        <% } %>
        <% if (error != null) { %>
        <div class="message-box error">Error: <%= error %></div>
        <% } %>

        <form action="contestant-feedback.jsp" method="POST">

            <label for="contestantId">Select Contestant:</label>
            <select id="contestantId" name="contestantId" required>
                <option value="" disabled selected>--- Choose a Contestant ---</option>
                <%
                    for (Map.Entry<String, String> entry : contestants.entrySet()) {
                        out.println("<option value=\"" + entry.getKey() + "\">" + entry.getValue() + "</option>");
                    }
                %>
            </select>

            <label>Performance Rating (Stars):</label>
            <div class="rating">
                <input type="radio" id="star5" name="rating" value="5" required />
                <label for="star5" title="5 Stars">★</label>
                <input type="radio" id="star4" name="rating" value="4" />
                <label for="star4" title="4 Stars">★</label>
                <input type="radio" id="star3" name="rating" value="3" />
                <label for="star3" title="3 Stars">★</label>
                <input type="radio" id="star2" name="rating" value="2" />
                <label for="star2" title="2 Stars">★</label>
                <input type="radio" id="star1" name="rating" value="1" />
                <label for="star1" title="1 Star">★</label>
            </div>

            <label for="feedbackText">Detailed Feedback/Comments:</label>
            <textarea id="feedbackText" name="feedbackText" rows="6" placeholder="Provide specific, constructive feedback..." required></textarea>

            <button type="submit" class="submit-btn">Submit Feedback</button>
        </form>
    </div>
</div>
</body>
</html>