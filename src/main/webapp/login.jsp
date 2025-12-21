<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Title -->
    <title>Login | VOTESTAGE</title>

    <!-- Favicon -->
    <link rel="icon" href="img/core-img/favicon.ico">

    <!-- Stylesheet -->
    <link rel="stylesheet" href="style.css">

    <style>
        .login-form .form-control {
            background-color: #fff;
            color: #000;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 10px 12px;
            font-size: 15px;
            font-style: normal;
        }

        .login-form .form-control:focus {
            border-color: #ff084e;
            box-shadow: 0 0 5px rgba(255, 8, 78, 0.4);
            outline: none;
        }

        .login-form label {
            font-weight: 500;
            margin-bottom: 6px;
            display: block;
            color: #333;
        }

        .login-form .btn {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
        }

        /* Password toggle button */
        #togglePassword {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            padding: 4px;
            cursor: pointer;
            color: #666;
        }

        #togglePassword:hover {
            color: #ff084e;
        }
    </style>
</head>

<body>

<!-- ##### Breadcumb Area Start ##### -->
<section class="breadcumb-area bg-img bg-overlay" style="background-image: url(img/bg-img/breadcumb3.jpg);">
    <div class="bradcumbContent">
        <h2>Login</h2>
    </div>
</section>
<!-- ##### Breadcumb Area End ##### -->

<!-- ##### Login Area Start ##### -->
<section class="login-area section-padding-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-8">
                <div class="login-content">
                    <h3>Welcome Back</h3>
                    <!-- Login Form -->
                    <div class="login-form">
                        <form action="login" method="post">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <div style="position: relative;">
                                    <input type="password" class="form-control" id="password" name="password" required aria-describedby="togglePassword">
                                    <button type="button"
                                            id="togglePassword"
                                            aria-label="Show password"
                                            title="Show password">
                                        <!-- Eye (visible) -->
                                        <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z"></path>
                                            <circle cx="12" cy="12" r="3"></circle>
                                        </svg>
                                        <!-- Eye slash (hidden) -->
                                        <svg id="eyeClose" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                             style="display:none;">
                                            <path d="M17.94 17.94A10.94 10.94 0 0112 20c-7 0-11-8-11-8a21.3 21.3 0 015.14-6.08"></path>
                                            <path d="M1 1l22 22"></path>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn oneMusic-btn mt-30">Login</button>
                        </form>
                        <div class="mt-3 text-center">
                            <a href="register.jsp">Don't have an account? Register</a>
                        </div>
                    </div>
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                    <div style="color:red;text-align:center;"><%= error %></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- ##### Login Area End ##### -->

<!-- ##### Script for Password Toggle ##### -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const toggleBtn = document.getElementById('togglePassword');
        const pwd = document.getElementById('password');
        const eyeOpen = document.getElementById('eyeOpen');
        const eyeClose = document.getElementById('eyeClose');

        toggleBtn.addEventListener('click', function () {
            if (pwd.type === 'password') {
                pwd.type = 'text';
                eyeOpen.style.display = 'none';
                eyeClose.style.display = 'inline';
                toggleBtn.setAttribute('aria-label', 'Hide password');
                toggleBtn.title = 'Hide password';
            } else {
                pwd.type = 'password';
                eyeOpen.style.display = 'inline';
                eyeClose.style.display = 'none';
                toggleBtn.setAttribute('aria-label', 'Show password');
                toggleBtn.title = 'Show password';
            }
        });
    });
</script>

</body>
</html>