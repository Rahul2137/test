<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create New Customer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .form-container {
            width: 400px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container h2 {
            text-align: center;
        }
        .form-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .form-row label,
        .form-row input {
            width: 48%; /* Two fields side by side with a little gap */
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input {
            padding: 10px;
            box-sizing: border-box;
        }
        button {
            background-color: #4caf50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }
    </style>
    <script>
            function submitForm() {
                var formData = {
                    first_name: document.getElementById("firstName").value,
                    last_name: document.getElementById("lastName").value,
                    street: document.getElementById("street").value,
                    address: document.getElementById("address").value,
                    city: document.getElementById("city").value,
                    state: document.getElementById("state").value,
                    email: document.getElementById("email").value,
                    phone: document.getElementById("phone").value
                };
                fetch('/createCustomer', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': window.localStorage.getItem("token")
                    },
                    body: JSON.stringify(formData),
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    alert("Customer created successfully!");
                    window.location.href = "/customers";
                })
                .catch(error => {
                    console.log(error);
                    alert(`Error creating customer: ${error.message}`);
                });
                return false;
            }
        </script>
</head>
<body>
    <div class="form-container">
        <h2>Create New Customer</h2>
        <form onsubmit="return submitForm()">
            <div class="form-row">
                <label for="firstName">First Name<span style="color: red;">*</span>:</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>

            <div class="form-row">
                <label for="lastName">Last Name<span style="color: red;">*</span>:</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>

            <div class="form-row">
                <label for="street">Street:</label>
                <input type="text" id="street" name="street">
            </div>

            <div class="form-row">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address">
            </div>

            <div class="form-row">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" >
            </div>

            <div class="form-row">
                <label for="state">State:</label>
                <input type="text" id="state" name="state" >
            </div>

            <div class="form-row">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email">
            </div>

            <div class="form-row">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone">
            </div>

            <button type="submit">Create Customer</button>
        </form>
    </div>
</body>
</html>
