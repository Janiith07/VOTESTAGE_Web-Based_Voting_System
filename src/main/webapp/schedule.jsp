<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Schedule Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --border: #dee2e6;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --radius: 12px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
        }

        .header h1 {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .header p {
            color: var(--gray);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .card-header {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h2 {
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body {
            padding: 25px;
        }

        .schedule-table {
            width: 100%;
            border-collapse: collapse;
        }

        .schedule-table th {
            background-color: #f1f5fd;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: var(--primary);
            border-bottom: 2px solid var(--border);
        }

        .schedule-table td {
            padding: 15px;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }

        .schedule-table tr:last-child td {
            border-bottom: none;
        }

        .schedule-table tr:hover {
            background-color: #f9fafd;
        }

        .contestant-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .contestant-img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e9ecef;
            transition: var(--transition);
        }

        .contestant-img:hover {
            transform: scale(1.05);
            border-color: var(--primary);
        }

        .contestant-name {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .slot-select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background-color: white;
            font-size: 1rem;
            color: var(--dark);
            cursor: pointer;
            transition: var(--transition);
        }

        .slot-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--secondary);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(67, 97, 238, 0.3);
        }

        .btn-secondary {
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-secondary:hover {
            background: #f1f5fd;
            transform: translateY(-2px);
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-scheduled {
            background: #e7f7ef;
            color: #0ca678;
        }

        .footer {
            text-align: center;
            margin-top: 40px;
            color: var(--gray);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }

            .contestant-info {
                flex-direction: column;
                text-align: center;
                gap: 8px;
            }

            .actions {
                flex-direction: column;
                gap: 15px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-calendar-alt"></i> Performance Schedule</h1>
        <p>Manage performance slots for contestants. Drag and drop or use the dropdowns to assign time slots.</p>
    </div>

    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-users"></i> Contestants & Schedule</h2>
            <div class="status-indicator status-scheduled">
                <i class="fas fa-check-circle"></i> 5 Performances Scheduled
            </div>
        </div>

        <div class="card-body">
            <form action="UpdateScheduleServlet" method="post">
                <table class="schedule-table">
                    <thead>
                    <tr>
                        <th width="40%">Contestant</th>
                        <th width="40%">Performance Slot</th>
                        <th width="20%">Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String[][] contestants = {
                                {"DJ Nova", "8:30 PM - 8:45 PM"},
                                {"MC Blaze", "8:45 PM - 9:00 PM"},
                                {"Luna Star", "9:00 PM - 9:15 PM"},
                                {"Beat King", "9:15 PM - 9:30 PM"},
                                {"Rhythm Queen", "9:30 PM - 9:45 PM"}
                        };

                        String[] slots = {
                                "8:30 PM - 8:45 PM",
                                "8:45 PM - 9:00 PM",
                                "9:00 PM - 9:15 PM",
                                "9:15 PM - 9:30 PM",
                                "9:30 PM - 9:45 PM"
                        };

                        for(int i=0; i<contestants.length; i++){
                            String name = contestants[i][0];
                            String currentSlot = contestants[i][1];
                    %>
                    <tr>
                        <td>
                            <div class="contestant-info">
                                <img src="img/bg-img/<%=name.toLowerCase().replace(" ","_")%>.jpg"
                                     alt="<%=name%>" class="contestant-img">
                                <div>
                                    <div class="contestant-name"><%=name%></div>
                                    <div style="font-size: 0.85rem; color: var(--gray);">
                                        <i class="fas fa-music"></i> Electronic
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <select name="slot_<%=i%>" class="slot-select">
                                <% for(String s: slots) { %>
                                <option value="<%=s%>" <%= s.equals(currentSlot) ? "selected" : "" %> ><%=s%></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <div class="status-indicator status-scheduled">
                                <i class="fas fa-check"></i> Confirmed
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>

                <div class="actions">
                    <a href="contestant-dashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Update Schedule
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>

<script>
    // Add some interactivity to the form
    document.addEventListener('DOMContentLoaded', function() {
        const selects = document.querySelectorAll('.slot-select');

        selects.forEach(select => {
            select.addEventListener('change', function() {
                // Visual feedback when a slot is changed
                this.style.backgroundColor = '#f0f4ff';
                this.style.borderColor = '#4361ee';

                setTimeout(() => {
                    this.style.backgroundColor = '';
                    this.style.borderColor = '';
                }, 1000);
            });
        });

        // Form submission feedback
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.disabled = true;
        });
    });
</script>
</body>
</html>
