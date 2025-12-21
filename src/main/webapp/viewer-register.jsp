<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Title -->
    <title>Viewer Login | VOTESTAGE</title>

    <!-- Favicon -->
    <link rel="icon" href="img/core-img/favicon.ico">

    <!-- Stylesheet -->
    <link rel="stylesheet" href="style.css">

    <style>
        .register-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url("img/bg-img/bg-2.jpg") no-repeat center center/cover;
        }

        .register-box {
            background: rgba(0, 0, 0, 0.7);
            padding: 40px;
            border-radius: 15px;
            max-width: 450px;
            width: 100%;
            color: #fff;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.4);
            text-align: center;
        }

        .register-box h2 {
            margin-bottom: 25px;
            font-size: 28px;
            font-weight: bold;
            color: #fff;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border-radius: 8px;
            border: none;
            outline: none;
            font-size: 15px;
        }

        .register-btn {
            margin-top: 15px;
            padding: 12px;
            background: #ff084e;
            border: none;
            color: #fff;
            width: 100%;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .register-btn:hover {
            background: #ff3366;
        }

        .login-link {
            margin-top: 15px;
            display: block;
            color: #bbb;
        }

        .login-link a {
            color: #ff084e;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>

<body>
<!-- Preloader -->
<div class="preloader d-flex align-items-center justify-content-center">
    <div class="lds-ellipsis">
        <div></div><div></div><div></div><div></div>
    </div>
</div>

<!-- Header -->
<header class="header-area">
    <div class="oneMusic-main-menu">
        <div class="classy-nav-container breakpoint-off">
            <div class="container">
                <nav class="classy-navbar justify-content-between" id="VoteStageNav">

                    <!-- Navbar Toggler -->
                    <div class="classy-navbar-toggler">
                        <span class="navbarToggler"><span></span><span></span><span></span></span>
                    </div>

                    <!-- Menu -->
                    <div class="classy-menu">
                        <div class="classycloseIcon">
                            <div class="cross-wrap"><span class="top"></span><span class="bottom"></span></div>
                        </div>
                        <div class="classynav">
                            <ul>
                                <li><a href="index.jsp">Home</a></li>
                                <li class="active"><a href="viewer-register.jsp">Viewer Login</a></li>
                            </ul>
                            <div class="login-register-cart-button d-flex align-items-center">
                                <div class="login-register-btn mr-50">
                                    <a href="login.jsp" id="loginBtn">Login</a>
                                </div>
                            </div>
                        </div>
                    </div>

                </nav>
            </div>
        </div>
    </div>
</header>

<!-- Viewer Login Section -->
<section class="register-section">
    <div class="register-box wow fadeInUp" data-wow-delay="200ms">
        <h2>Enter as a Viewer</h2>
        <form action="viewerLogin" method="post">
            <div class="form-group">
                <label for="viewerName">Unique Name</label>
                <input type="text" name="viewerName" id="viewerName" placeholder="Enter a unique name" required>
            </div>
            <button type="submit" class="register-btn">Continue</button>
        </form>
        <p class="login-link"><a href="index.jsp">Back to Home</a></p>
    </div>
</section>

<!-- Scripts -->
<script src="js/jquery/jquery-2.2.4.min.js"></script>
<script src="js/bootstrap/popper.min.js"></script>
<script src="js/bootstrap/bootstrap.min.js"></script>
<script src="js/plugins/plugins.js"></script>
<script src="js/active.js"></script>
</body>
</html>
