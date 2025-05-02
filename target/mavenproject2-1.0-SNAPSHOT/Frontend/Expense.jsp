<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ include file="navbar.jsp" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expense Tracking System</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
            }

            body {
                margin-top:90px;
                background-image: linear-gradient(to top, #30cfd0 0%, #330867 100%);
                background-size: cover;
                background-repeat: no-repeat;
                background-attachment: fixed;
                width: 100%;
            }

            .container {
                max-width: 1200px;
                margin: 20px auto;
                background-color: #f9f9f9;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 5px;
            }

            h1 {
                text-align: center;
                font-size: 28px;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                margin-top: 20px;
            }

            th, td {
                text-align: center;
                padding: 8px;
            }

            .form-panel {
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                background-color: #f9f9f9;
            }

            .btn-row {
                margin-top: 10px;
                text-align: center;
            }

            .btn-row button {
                margin: 5px;
                transition: all 0.3s ease;
            }

            .btn-row button:hover {
                transform: scale(1.1);
            }

            .fade-in {
                animation: fadeIn 0.5s ease-in-out;
            }

            .fade-out {
                animation: fadeOut 0.5s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes fadeOut {
                from {
                    opacity: 1;
                }
                to {
                    opacity: 0;
                }
            }

            .btn-custom {
                background-color: #dc3545;
                border-color: #dc3545;
                color: white;
            }

            .btn-custom:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Expense Tracking System</h1>
            <div class="row">
                <div class="col-md-4">
                    <div class="form-panel">
                        <form id="expenseForm" action="../ExpenseData" method="post">
                            <input type="hidden" id="expenseId" name="id">
                            <div class="form-group">
                                <label for="title">Title:</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="description">Description:</label>
                                <input type="text" class="form-control" id="description" name="description">
                            </div>
                            <div class="form-group">
                                <label for="amount">Expense (Rs):</label>
                                <input type="number" class="form-control" id="amount" name="amount" step="0.01" required>
                            </div>
                            <div class="form-group">
                                <label for="date">Date:</label>
                                <input type="date" class="form-control" id="date" name="date" required>
                            </div>
                            <div class="form-group">
                                <label for="category">Category:</label>
                                <select class="form-control" id="category" name="category">
                                    <%
                                        List<String> categories = new ArrayList<>();
                                        Connection conn = null;
                                        Statement stmt = null;
                                        ResultSet rs = null;

                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
                                            stmt = conn.createStatement();
                                            String query = "SELECT DISTINCT name FROM expense_categories";
                                            rs = stmt.executeQuery(query);

                                            while (rs.next()) {
                                                categories.add(rs.getString("name"));
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rs != null) try {
                                                rs.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                            if (stmt != null) try {
                                                stmt.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                            if (conn != null) try {
                                                conn.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }

                                        for (String category : categories) {
                                    %>
                                    <option value="<%= category%>"><%= category%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="method">Payment Method:</label>
                                <input type="text" class="form-control" id="method" name="method">
                            </div>
                            <div class="btn-row">
                                <button type="submit" class="btn btn-custom" name="action" value="add">Add</button>
                                <button type="button" class="btn btn-info" onclick="editExpense()">Edit</button>
                                <button type="button" class="btn btn-danger" onclick="deleteSelected()">Delete Selected</button>
                                <button type="submit" class="btn btn-warning" name="action" value="update">Update</button>
                                <button type="button" class="btn btn-secondary" onclick="clearForm()">Clear</button>
                                <a href="home.jsp" class="btn btn-primary">Back</a>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="col-md-8">
                    <table id="expenseTable" class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th></th>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Expense (Rs)</th>
                                <th>Date</th>
                                <th>Category</th>

                            </tr>
                        </thead>
                        <tbody id="expenseTableBody">
                            <%
                                Connection conn2 = null;
                                Statement stmt2 = null;
                                ResultSet rs2 = null;
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
                                    stmt2 = conn2.createStatement();
                                    rs2 = stmt2.executeQuery("SELECT * FROM expense");

                                    while (rs2.next()) {
                                        int id = rs2.getInt("id");
                                        String title = rs2.getString("title");
                                        String description = rs2.getString("description");
                                        double amount = rs2.getDouble("amount");
                                        String date = rs2.getString("date");
                                        String category = rs2.getString("category");
                                       
                            %>
                            <tr id="row-<%= id%>">
                                <td><input type="checkbox" name="expenseIds" value="<%= id%>"></td>
                                <td><%= id%></td>
                                <td><%= title%></td>
                                <td><%= description%></td>
                                <td><%= amount%></td>
                                <td><%= date%></td>
                                <td><%= category%></td>

                            </tr>
                            <%
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function editExpense() {
                var selectedId = getSelectedExpenseId();
                if (selectedId) {
                    document.getElementById("expenseId").value = selectedId;
                    // Populate form fields with selected expense data
                    var table = document.getElementById('expenseTable');
                    var selectedRow;
                    for (var i = 1; i < table.rows.length; i++) {
                        if (table.rows[i].cells[0].querySelector('input[type="checkbox"]').checked) {
                            selectedRow = table.rows[i];
                            break;
                        }
                    }
                    if (selectedRow) {
                        document.getElementById("title").value = selectedRow.cells[2].innerText;
                        document.getElementById("description").value = selectedRow.cells[3].innerText;
                        document.getElementById("amount").value = selectedRow.cells[4].innerText;
                        document.getElementById("date").value = selectedRow.cells[5].innerText;
                        document.getElementById("category").value = selectedRow.cells[6].innerText;
                        document.getElementById("method").value = selectedRow.cells[7].innerText;
                    }
                }
            }

            function deleteSelected() {
                var selectedIds = [];
                var checkboxes = document.getElementsByName("expenseIds");

                for (var i = 0; i < checkboxes.length; i++) {
                    if (checkboxes[i].checked) {
                        selectedIds.push(checkboxes[i].value);
                    }
                }

                if (selectedIds.length === 0) {
                    alert("Please select at least one expense entry to delete.");
                    return;
                }

                if (confirm("Are you sure you want to delete the selected expense entries?")) {
                    var form = document.createElement("form");
                    form.action = "../ExpenseData"; // Adjust the action URL as per your setup
                    form.method = "post";

                    // Create action input (for identifying the action in servlet)
                    var actionInput = document.createElement("input");
                    actionInput.type = "hidden";
                    actionInput.name = "action";
                    actionInput.value = "deleteSelected";
                    form.appendChild(actionInput);

                    // Create inputs for selected IDs
                    selectedIds.forEach(function (id) {
                        var idInput = document.createElement("input");
                        idInput.type = "hidden";
                        idInput.name = "selectedIds";
                        idInput.value = id;
                        form.appendChild(idInput);
                    });

                    // Append form to body and submit
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function clearForm() {
                document.getElementById("expenseId").value = "";
                document.getElementById("title").value = "";
                document.getElementById("description").value = "";
                document.getElementById("amount").value = "";
                document.getElementById("date").value = "";
                document.getElementById("category").value = "";
                document.getElementById("method").value = "";
            }

            function getSelectedExpenseId() {
                var checkboxes = document.getElementsByName("expenseIds");

                for (var i = 0; i < checkboxes.length; i++) {
                    if (checkboxes[i].checked) {
                        return checkboxes[i].value;
                    }
                }

                alert("Please select an expense entry to edit.");
                return null;
            }
        </script>
    </body>
</html>
