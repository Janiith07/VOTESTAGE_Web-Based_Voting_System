<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.voting.model.Person" %>
<%@ page import="com.voting.dao.PersonDAO" %>
<%
  @SuppressWarnings("unchecked")
  List<Person> allUsers = (List<Person>) request.getAttribute("users");
  if (allUsers == null) {
    try {
      allUsers = PersonDAO.getAllPersons();
    } catch (Exception e) {
      allUsers = java.util.Collections.emptyList();
      request.setAttribute("error", "Failed to load users: " + e.getMessage());
    }
  }

  List<Person> admins = new ArrayList<>();
  List<Person> voters = new ArrayList<>();
  List<Person> judges = new ArrayList<>();
  List<Person> contestantManagers = new ArrayList<>();
  List<Person> supporters = new ArrayList<>();

  for (Person user : allUsers) {
    String role = user.getRole();
    if (role != null) {
      role = role.trim().toLowerCase();
      switch (role) {
        case "admin":
          admins.add(user);
          break;
        case "voter":
          voters.add(user);
          break;
        case "judge":
          judges.add(user);
          break;
        case "contestantmanager":
          contestantManagers.add(user);
          break;
        case "itsupporter":
          supporters.add(user);
          break;
      }
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Users</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root{
      --primary-color: #A777E3;
      --primary-dark: #8B5FCF;
      --primary-light: #C499F7;
      --primary-lighter: #E8D5F5;
      --success-color: #28A745;
      --warning-color: #FFC107;
      --danger-color: #DC3545;
      --info-color: #17A2B8;
      --secondary-color: #6C757D;
      --white: #ffffff;
      --black: #222222;
      --gray-light: #f8f9fa;
      --gray-dark: #6c757d;
      --radius: 12px;
    }

    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: 'Poppins', Arial, sans-serif;
      background: #A777E3FF;
      color: var(--black);
      font-size:14px;
    }

    .navbar{
      background: var(--primary-color);
      color: var(--white);
      padding:18px 36px;
      display:flex;
      align-items:center;
      justify-content:space-between;
    }
    .navbar h1{
      margin:0;
      font-size:18px;
      font-weight:600;
    }
    .nav-links a{
      color: var(--white);
      text-decoration:none;
      margin-left:18px;
      font-weight:500;
      padding:8px 12px;
      border-radius:8px;
    }
    .nav-links a.btn-logout{
      background: var(--white);
      color: var(--primary-color);
      border:1px solid var(--white);
    }

    .container{
      max-width:1200px;
      margin:36px auto;
      background: var(--white);
      padding:32px;
      border-radius: var(--radius);
      border: 2px solid var(--primary-color);
    }

    h2{
      margin:0 0 16px 0;
      color: var(--primary-color);
      font-size:22px;
      font-weight:600;
    }

    .top-actions{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:12px;
      margin-bottom:22px;
    }
    .btn{
      padding:9px 14px;
      border:none;
      border-radius:8px;
      text-decoration:none;
      font-size:13px;
      cursor:pointer;
      display:inline-flex;
      align-items:center;
      gap:8px;
      font-weight: 500;
      transition: all 0.2s ease;
    }
    .btn:hover{
      opacity: 0.9;
      transform: translateY(-1px);
    }
    .btn-edit{
      background: var(--info-color);
      color: var(--white);
      border: 1px solid var(--info-color);
    }
    .btn-edit:hover{
      background: #138496;
      border-color: #138496;
    }
    .btn-role{
      background: var(--warning-color);
      color: var(--black);
      border: 1px solid var(--warning-color);
    }
    .btn-role:hover{
      background: #e0a800;
      border-color: #e0a800;
    }
    .btn-delete{
      background: var(--danger-color);
      color: var(--white);
      border: 1px solid var(--danger-color);
    }
    .btn-delete:hover{
      background: #c82333;
      border-color: #c82333;
    }
    .btn-add{
      background: var(--success-color);
      color: var(--white);
      border: 1px solid var(--success-color);
    }
    .btn-add:hover{
      background: #218838;
      border-color: #218838;
    }
    .btn-logout{
      background: var(--white);
      color: var(--primary-color);
      padding:8px 12px;
      border: 2px solid var(--primary-color);
    }
    .btn-logout:hover{
      background: var(--primary-light);
      color: var(--white);
    }

    /* Additional professional button styles */
    .btn-primary{
      background: var(--primary-color);
      color: var(--white);
      border: 1px solid var(--primary-color);
    }
    .btn-primary:hover{
      background: var(--primary-dark);
      border-color: var(--primary-dark);
    }

    .btn-secondary{
      background: var(--secondary-color);
      color: var(--white);
      border: 1px solid var(--secondary-color);
    }
    .btn-secondary:hover{
      background: #5a6268;
      border-color: #5a6268;
    }

    .btn-outline-primary{
      background: transparent;
      color: var(--primary-color);
      border: 2px solid var(--primary-color);
    }
    .btn-outline-primary:hover{
      background: var(--primary-color);
      color: var(--white);
    }

    .btn-sm{
      padding: 6px 10px;
      font-size: 12px;
    }

    .btn-lg{
      padding: 12px 18px;
      font-size: 16px;
    }

    table{
      width:100%;
      border-collapse:collapse;
      border: 2px solid var(--primary-color);
      background: var(--white);
    }
    th, td{
      padding:14px 16px;
      text-align:left;
      vertical-align:middle;
      white-space:nowrap;
      overflow:hidden;
      text-overflow:ellipsis;
      border: 1px solid var(--primary-color);
    }
    th{
      background: var(--primary-color);
      color: var(--white);
      font-weight:600;
      font-size:13px;
    }
    tbody tr:nth-child(even){
      background: var(--gray-light);
    }

    .actions{ display:flex; gap:10px; align-items:center; }

    .form-popup{
      padding:12px 16px;
      border-radius:10px;
      margin-bottom:18px;
      font-weight:500;
      display:inline-block;
    }

    .stats-row{ display:flex; gap:14px; margin-bottom:20px; align-items:stretch; }
    .stat-card{
      flex:1;
      padding:18px;
      border-radius:10px;
      color: var(--white);
      border: 2px solid var(--primary-color);
      display:flex;
      flex-direction:column;
      justify-content:center;
      align-items:flex-start;
      min-width:140px;
    }
    .stat-card h4{ margin:0 0 6px 0; font-size:13px; text-transform:uppercase; }
    .stat-card .number{ font-size:28px; font-weight:700; margin:0; }

    .stat-card.admin{ background: var(--primary-color); }
    .stat-card.voter{ background: var(--primary-color); }
    .stat-card.judge{ background: var(--primary-color); }
    .stat-card.contestant{ background: var(--primary-color); }
    .stat-card.supporter{ background: var(--primary-color); }

    .tabs{
      display:flex;
      gap:10px;
      margin-bottom:18px;
      align-items:center;
      flex-wrap:nowrap;
    }
    .tab-button{
      padding:10px 18px;
      background: var(--white);
      border: 2px solid var(--primary-color);
      border-radius:10px;
      cursor:pointer;
      font-weight:600;
      color: var(--primary-color);
      display:flex;
      align-items:center;
      gap:8px;
      transition: all 0.2s ease;
    }
    .tab-button:hover{
      background: var(--primary-light);
      color: var(--white);
    }
    .tab-button:hover .count-badge{
      background: var(--white);
      color: var(--primary-color);
    }
    .tab-button .count-badge{
      background: var(--primary-color);
      color: var(--white);
      padding:2px 8px;
      border-radius:12px;
      font-size:12px;
      font-weight:700;
      transition: all 0.2s ease;
    }
    .tab-button.active{
      background: var(--primary-color);
      color: var(--white);
    }
    .tab-button.active .count-badge{
      background: var(--white);
      color: var(--primary-color);
    }

    .tab-content{ display:none; }
    .tab-content.active{ display:block; }

    .role-header{
      display:flex;
      justify-content:space-between;
      align-items:center;
      margin-bottom:14px;
      padding:12px 14px;
      border-radius:8px;
      color: var(--white);
      background: var(--primary-color);
    }
    .role-header h3{ margin:0; font-size:16px; font-weight:600 }
    .role-header .count{
      background: var(--white);
      color: var(--primary-color);
      padding:6px 12px;
      border-radius:20px;
      font-weight:700;
    }

    .empty-state{
      text-align:center;
      padding:40px 12px;
      color: var(--gray-dark);
      font-size:15px;
    }

    .footer{
      text-align:center;
      color: var(--gray-dark);
      margin-top:18px;
      font-size:13px;
    }

    @media (max-width: 1100px){
      .container{ padding:22px; margin:20px; }
      th, td{ padding:12px; font-size:13px; }
    }
  </style>
</head>
<body>

<div class="navbar">
  <h1>User Management Dashboard</h1>
  <div class="nav-links">
    <a href="voter-dashboard.jsp">Account</a>
    <a href="index.jsp" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container">

  <div class="top-actions">
    <a href="add-user.jsp" class="btn btn-add">+ Add New User</a>
    <p style="font-weight:600; color:#333; margin:0;">Total Users: <span style="color:var(--primary-color)"><%= allUsers.size() %></span></p>
  </div>

  <%
    String message = (String) request.getAttribute("message");
    if (message == null) {
      message = request.getParameter("message");
    }
    String error = request.getParameter("error");
    if (message != null) {
  %>
  <div class="form-popup" style="background:#e6ffed; border:1px solid #c8f6d2; color:#19692a;">
    ✓ <%= message %>
  </div>
  <% } %>
  <% if (error != null) { %>
  <div class="form-popup" style="background:#fff0f0; border:1px solid #ffd0d0; color:#7a1b1b;">
    ✗ <%= error %>
  </div>
  <% } %>

  <div class="stats-row">
    <div class="stat-card admin">
      <h4>Admins</h4>
      <p class="number"><%= admins.size() %></p>
    </div>
    <div class="stat-card voter">
      <h4>Voters</h4>
      <p class="number"><%= voters.size() %></p>
    </div>
    <div class="stat-card judge">
      <h4>Judges</h4>
      <p class="number"><%= judges.size() %></p>
    </div>
    <div class="stat-card contestant">
      <h4>ContestantManagers</h4>
      <p class="number"><%= contestantManagers.size() %></p>
    </div>
    <div class="stat-card supporter">
      <h4>IT Supporters</h4>
      <p class="number"><%= supporters.size() %></p>
    </div>
  </div>

  <div class="tabs" role="tablist" aria-label="User role tabs">
    <button class="tab-button active" data-role="admin" onclick="showTab('admin', event)">
      Admins <span class="count-badge"><%= admins.size() %></span>
    </button>
    <button class="tab-button" data-role="voter" onclick="showTab('voter', event)">
      Voters <span class="count-badge"><%= voters.size() %></span>
    </button>
    <button class="tab-button" data-role="judge" onclick="showTab('judge', event)">
      Judges <span class="count-badge"><%= judges.size() %></span>
    </button>
    <button class="tab-button" data-role="contestant" onclick="showTab('contestant', event)">
      ContestantManagers <span class="count-badge"><%= contestantManagers.size() %></span>
    </button>
    <button class="tab-button" data-role="supporter" onclick="showTab('supporter', event)">
      IT Supporters <span class="count-badge"><%= supporters.size() %></span>
    </button>
  </div>

  <div id="admin-tab" class="tab-content active">
    <% if (admins.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:34px; margin:0;"></p>
      <p>No admins found</p>
    </div>
    <% } else { %>
    <div class="role-header">
      <h3>Admins</h3>
      <div class="count"><%= admins.size() %> total</div>
    </div>
    <table>
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Name</th>
        <th>Email</th>
        <th style="width:260px">Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Person user : admins) { %>
      <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td class="actions">
          <a href="edit-user?id=<%= user.getId() %>" class="btn btn-edit">Edit</a>
          <a href="change-role.jsp?id=<%= user.getId() %>" class="btn btn-role">Change Role</a>
          <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this admin?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div id="voter-tab" class="tab-content">
    <% if (voters.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:34px; margin:0;"></p>
      <p>No voters found</p>
    </div>
    <% } else { %>
    <div class="role-header">
      <h3>Voters</h3>
      <div class="count"><%= voters.size() %> total</div>
    </div>
    <table>
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Name</th>
        <th>Email</th>
        <th style="width:260px">Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Person user : voters) { %>
      <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td class="actions">
          <a href="edit-user?id=<%= user.getId() %>" class="btn btn-edit">Edit</a>
          <a href="change-role.jsp?id=<%= user.getId() %>" class="btn btn-role">Change Role</a>
          <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this voter?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div id="judge-tab" class="tab-content">
    <% if (judges.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:34px; margin:0;"></p>
      <p>No judges found</p>
    </div>
    <% } else { %>
    <div class="role-header">
      <h3>Judges</h3>
      <div class="count"><%= judges.size() %> total</div>
    </div>
    <table>
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Name</th>
        <th>Email</th>
        <th style="width:260px">Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Person user : judges) { %>
      <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td class="actions">
          <a href="edit-user?id=<%= user.getId() %>" class="btn btn-edit">Edit</a>
          <a href="change-role.jsp?id=<%= user.getId() %>" class="btn btn-role">Change Role</a>
          <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this judge?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div id="contestant-tab" class="tab-content">
    <% if (contestantManagers.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:34px; margin:0;"></p>
      <p>No contestant managers found</p>
    </div>
    <% } else { %>
    <div class="role-header">
      <h3>ContestantManagers</h3>
      <div class="count"><%= contestantManagers.size() %> total</div>
    </div>
    <table>
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Name</th>
        <th>Email</th>
        <th style="width:260px">Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Person user : contestantManagers) { %>
      <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td class="actions">
          <a href="edit-user?id=<%= user.getId() %>" class="btn btn-edit">Edit</a>
          <a href="change-role.jsp?id=<%= user.getId() %>" class="btn btn-role">Change Role</a>
          <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this contestant manager?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div id="supporter-tab" class="tab-content">
    <% if (supporters.isEmpty()) { %>
    <div class="empty-state">
      <p style="font-size:34px; margin:0;"></p>
      <p>No IT supporters found</p>
    </div>
    <% } else { %>
    <div class="role-header">
      <h3>IT Supporters</h3>
      <div class="count"><%= supporters.size() %> total</div>
    </div>
    <table>
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th>Name</th>
        <th>Email</th>
        <th style="width:260px">Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Person user : supporters) { %>
      <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td class="actions">
          <a href="edit-user?id=<%= user.getId() %>" class="btn btn-edit">Edit</a>
          <a href="change-role.jsp?id=<%= user.getId() %>" class="btn btn-role">Change Role</a>
          <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this IT supporter?')">Delete</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <div class="footer"></div>
</div>

<script>
  function showTab(tabName, evt) {
    var tabContents = document.getElementsByClassName('tab-content');
    for (var i = 0; i < tabContents.length; i++) {
      tabContents[i].classList.remove('active');
    }
    var tabButtons = document.getElementsByClassName('tab-button');
    for (var i = 0; i < tabButtons.length; i++) {
      tabButtons[i].classList.remove('active');
    }
    var selected = document.getElementById(tabName + '-tab');
    if (selected) selected.classList.add('active');
    var target = evt && evt.currentTarget ? evt.currentTarget : window.event && window.event.target ? window.event.target : null;
    if (target) {
      if (target.tagName.toLowerCase() !== 'button') {
        target = target.closest('button');
      }
      if (target) target.classList.add('active');
    }
  }

  window.onload = function() {
    var popups = document.getElementsByClassName('form-popup');
    if (popups.length > 0) {
      setTimeout(function() {
        for (var i = 0; i < popups.length; i++) {
          popups[i].style.transition = 'opacity 0.5s, transform 0.5s';
          popups[i].style.opacity = '0';
          popups[i].style.transform = 'translateY(-8px)';
        }
        setTimeout(function() {
          for (var i = 0; i < popups.length; i++) {
            popups[i].style.display = 'none';
          }
        }, 600);
      }, 5000);
    }
  };
</script>

</body>
</html>
