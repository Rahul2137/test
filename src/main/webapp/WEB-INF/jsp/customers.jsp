<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
   <head>
      <title>Customer Management</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
      <style>
         body {
         font-family: 'Arial', sans-serif;
         margin: 0;
         padding: 0;
         display: flex;
         flex-direction: column;
         align-items: center;
         justify-content: center;
         min-height: 100vh;
         background-color: #f5f5f5;
         }
         h2 {
         color: #333;
         text-align: center;
         margin-bottom: 20px;
         }
         button {
         padding: 10px 20px;
         margin: 8px;
         cursor: pointer;
         background-color: #4caf50;
         color: white;
         border: none;
         border-radius: 4px;
         }
         table {
         border-collapse: collapse;
         width: 70%;
         margin-top: 20px;
         background-color: white;
         border-radius: 8px;
         overflow: hidden;
         box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
         }
         th, td {
         border: 1px solid #ddd;
         padding: 12px;
         text-align: left;
         }
         th {
         background-color: #4caf50;
         color: white;
         }
         tr:hover {
         background-color: #f0f0f0;
         }
         .edit-button {
         background-color: #2196F3;
         }
         .delete-button {
         background-color: #f44336;
         }
         .loader {
         border: 8px solid #f3f3f3;
         border-top: 8px solid #3498db;
         border-radius: 50%;
         width: 50px;
         height: 50px;
         animation: spin 1s linear infinite;
         margin-bottom: 20px;
         display: none; /* initially hide loader */
         }
         @keyframes spin {
         0% { transform: rotate(0deg); }
         100% { transform: rotate(360deg); }
         }
      </style>
      <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
      <script>
         if (!window.localStorage.getItem("token")) {
             alert("You are not logged in, Kindly Login!");
             window.location.replace("/login");
         }

         document.addEventListener("DOMContentLoaded", function () {

             document.getElementById("loader").style.display = "block";

             fetch('/getCustomersData', {
                 method: 'GET',
                 headers: {
                     'Authorization': window.localStorage.getItem("token")
                 }
             })
             .then(async (response) => {
                 if (response.status == 200) {
                     const data = await response.json();
                     console.log(data);
                     populateTable(data.data); // Call function to populate table
                 } else if (response.status == 401) {
                     alert("You are not logged in, Kindly Login!");
                     window.location.replace("/login");
                 } else {
                     alert("Something Went Wrong. Please refresh.");
                     window.location.replace("/customers");
                 }
             })
             .catch(error => {
                 console.error('Error:', error);
             })
             .finally(() => {
                 // Hide loader when data is received
                 document.getElementById("loader").style.display = "none";
             });
         });

         function populateTable(data) {
             const tbody = document.getElementById("ta");

             // Iterate over data and populate the table
             data.forEach(c => {
                 var customer = JSON.parse(c);
                 const row = document.createElement("tr");

                 const firstNameCell = document.createElement("td");
                 firstNameCell.textContent = customer.first_name;

                 const lastNameCell = document.createElement("td");
                 lastNameCell.textContent = customer.last_name;

                 const addressCell = document.createElement("td");
                 addressCell.textContent = customer.address;

                 const cityCell = document.createElement("td");
                 cityCell.textContent = customer.city;

                 const stateCell = document.createElement("td");
                 stateCell.textContent = customer.state;

                 const emailCell = document.createElement("td");
                 emailCell.textContent = customer.email;

                 const phoneCell = document.createElement("td");
                 phoneCell.textContent = customer.phone;

                 const actionsCell = document.createElement("td");
                 const editButton = document.createElement("button");
                 editButton.className = "edit-button";
                 editButton.textContent = "Edit";
                 editButton.onclick = () => openEditModal(customer);

                 const deleteButton = document.createElement("button");
                 deleteButton.className = "delete-button";
                 deleteButton.textContent = "Delete";
                 deleteButton.onclick = () => deleteCustomer(customer.uuid);

                 actionsCell.appendChild(editButton);
                 actionsCell.appendChild(deleteButton);

                 row.appendChild(firstNameCell);
                 row.appendChild(lastNameCell);
                 row.appendChild(addressCell);
                 row.appendChild(cityCell);
                 row.appendChild(stateCell);
                 row.appendChild(emailCell);
                 row.appendChild(phoneCell);
                 row.appendChild(actionsCell);

                 tbody.appendChild(row);
             });
         }

         function openEditModal(customer) {
             // Populate modal form with customer details
             document.getElementById("firstName").value = customer.first_name;
             document.getElementById("lastName").value = customer.last_name;
             document.getElementById("street").value = customer.street;
             document.getElementById("address").value = customer.address;
             document.getElementById("email").value = customer.email;
             document.getElementById("phone").value = customer.phone;
             document.getElementById("city").value = customer.city;
             document.getElementById("state").value = customer.state;
             document.getElementById("uuid").value = customer.uuid;
             $('#editModal').modal('show');
         }

         function deleteCustomer(customerId) {
             document.getElementById("loader").style.display = "block";
             if (!window.localStorage.getItem("token")) {
                         alert("You are not logged in, Kindly Login!");
                         window.location.replace("/login");
             }
             let headersList = {
              "Authorization": "Bearer " + window.localStorage.getItem("token")
             }

             fetch("/deleteCustomer?uuid=" + customerId, {
               method: "POST",
               body: null,
               headers: headersList
             }).
             then(async (response) => {
                                document.getElementById("loader").style.display = "none";
                               if (response.status == 200) {
                                   alert("Customer Deleted Successfully");
                               } else if (response.status == 401) {
                                   alert("You are not logged in, Kindly Login!");
                                   window.location.replace("/login");
                               } else {
                                   alert("Something Went Wrong Customer not deleted. Please retry.");
                               }
                               window.location.reload();
                           })
                           .catch(error => {
                               console.error('Error:', error);
                               alert("Something Went Wrong Customer not deleted. Please retry.");
                           });
         }
         function updateCustomer() {
                         $('#editModal').modal('hide');
                         document.getElementById("loader").style.display = "block";
                         var formData = {
                             first_name: document.getElementById("firstName").value,
                             last_name: document.getElementById("lastName").value,
                             street: document.getElementById("street").value,
                             address: document.getElementById("address").value,
                             city: document.getElementById("city").value,
                             state: document.getElementById("state").value,
                             email: document.getElementById("email").value,
                             phone: document.getElementById("phone").value,
                             uuid: document.getElementById("uuid").value,
                         };
                         fetch('/updateCustomer', {
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
                             document.getElementById("loader").style.display = "none";
                             alert("Customer updated successfully!");
                             window.location.reload();
                         })
                         .catch(error => {
                             console.log(error);
                             document.getElementById("loader").style.display = "none";
                             alert(`Error creating customer: ${error.message}`);
                         });
                     }
      </script>
   </head>
   <body>
      <div class="loader" id="loader"></div>
      <h2>Customer Table</h2>
      <button onclick="window.location.href='/createcustomer'">Add Customer</button>
      <table>
         <thead>
            <tr>
               <th>First Name</th>
               <th>Last Name</th>
               <th>Address</th>
               <th>City</th>
               <th>State</th>
               <th>Email</th>
               <th>Phone</th>
               <th>Actions</th>
            </tr>
         </thead>
         <tbody id="ta">
         </tbody>
      </table>
      <!-- Edit Customer Modal -->
      <div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
         <div class="modal-dialog" role="document">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title" id="editModalLabel">Edit Customer Details</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                  </button>
               </div>
               <div class="modal-body">
                  <!-- Form to display and edit customer details -->
                  <form id="editForm">
                     <div class="form-group" hidden>
                        <label for="uuid">First Name<span style="color: red;">*</span>:</label>
                        <input type="text" id="uuid" class="form-control"  name="uuid" required>
                     </div>
                     <div class="form-group">
                        <label for="firstName">First Name<span style="color: red;">*</span>:</label>
                        <input type="text" id="firstName" class="form-control"  name="firstName" required>
                     </div>
                     <div class="form-group">
                        <label for="lastName">Last Name<span style="color: red;">*</span>:</label>
                        <input type="text" id="lastName" class="form-control"  name="lastName" required>
                     </div>
                     <div class="form-group">
                        <label for="street">Street:</label>
                        <input type="text" id="street" class="form-control"  name="street">
                     </div>
                     <div class="form-group">
                        <label for="address">Address:</label>
                        <input type="text" id="address" class="form-control"  name="address">
                     </div>
                     <div class="form-group">
                        <label for="city">City:</label>
                        <input type="text" id="city" class="form-control"  name="city" >
                     </div>
                     <div class="form-group">
                        <label for="state">State:</label>
                        <input type="text" id="state" class="form-control"  name="state" >
                     </div>
                     <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" class="form-control"  name="email">
                     </div>
                     <div class="form-group">
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" class="form-control"  name="phone">
                     </div>
                  </form>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary" onclick="updateCustomer()">Update</button>
               </div>
            </div>
         </div>
      </div>
   </body>
</html>