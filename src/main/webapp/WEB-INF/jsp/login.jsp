<!-- src/main/webapp/WEB-INF/views/login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .login-container {
            width: 300px;
            margin: auto;
            margin-top: 100px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4caf50;
            color: white;
            padding: 12px 20px;
            margin: 8px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
    <script>
            function submitForm() {
                var username = document.getElementById('username').value;
                var password = document.getElementById('password').value;

                fetch('/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username: username, password: password })
                })
                .then(async (response) => {
                    if(response.status == 200){
                           data = await response.json();
                           window.localStorage.setItem("token", data.token);
                           window.location.replace("/customers");
                    }else if(response.status == 401){
                           window.localStorage.removeItem("token");
                           alert("Wrong Credentials, Username or Password Wrong!");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            }
        </script>
</head>
<body>
    <div class="login-container">
        <h2>Login Form</h2>
        <form onsubmit="submitForm(); return false;">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <br>
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>
