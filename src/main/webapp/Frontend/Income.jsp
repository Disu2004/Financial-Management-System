<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Income Tracking System</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            margin-top: 90px;
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
            background-color: #28a745;
            border-color: #28a745;
            color: white;
        }

        .btn-custom:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }
    </style>
</head>
<body>
<div class="container">
    <%@ include file="navbar.jsp" %>
    <h1>Add Income</h1>
    <div class="row">
        <div class="col-md-4">
            <div class="form-panel">
                <form id="incomeForm" action="../IncomeData" method="post">
                    <input type="hidden" id="incomeId" name="id">
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <input type="text" class="form-control" id="description" name="description">
                    </div>
                    <div class="form-group">
                        <label for="amount">Income (Rs):</label>
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
                                    String query = "SELECT DISTINCT name FROM income_categories";
                                    rs = stmt.executeQuery(query);

                                    while (rs.next()) {
                                        categories.add(rs.getString("name"));
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                }

                                for (String category : categories) {
                            %>
                            <option value="<%= category %>"><%= category %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="source">Source:</label>
                        <input type="text" class="form-control" id="source" name="source">
                    </div>
                    <div class="btn-row">
                        <button type="submit" class="btn btn-custom" name="action" value="add">Add</button>
                        <button type="button" class="btn btn-info" onclick="editIncome()">Edit</button>
                        <button type="button" class="btn btn-danger" onclick="deleteSelected()">Delete Selected</button>
                        <button type="submit" class="btn btn-warning" name="action" value="update">Update</button>
                        <button type="button" class="btn btn-secondary" onclick="clearForm()">Clear</button>
                        <a href="home.jsp" class="btn btn-primary">Back</a>
                    </div>
                </form>
            </div>
        </div>
        <div class="col-md-8">
            <table id="incomeTable" class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th></th>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Income (Rs)</th>
                    <th>Date</th>
                    <th>Category</th>
                    <th>Source</th>
                </tr>
                </thead>
                <tbody id="incomeTableBody">
                <%
                    Connection conn2 = null;
                    Statement stmt2 = null;
                    ResultSet rs2 = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
                        stmt2 = conn2.createStatement();
                        rs2 = stmt2.executeQuery("SELECT * FROM income");

                        while (rs2.next()) {
                            int id = rs2.getInt("id");
                            String title = rs2.getString("title");
                            String description = rs2.getString("description");
                            double amount = rs2.getDouble("amount");
                            String date = rs2.getString("date");
                            String category = rs2.getString("category");
                            String source = rs2.getString("source");
                %>
                <tr id="row-<%= id %>">
                    <td><input type="checkbox" name="incomeIds" value="<%= id %>"></td>
                    <td><%= id %></td>
                    <td><%= title %></td>
                    <td><%= description %></td>
                    <td><%= amount %></td>
                    <td><%= date %></td>
                    <td><%= category %></td>
                    <td><%= source %></td>
                </tr>
                <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs2 != null) try { rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmt2 != null) try { stmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn2 != null) try { conn2.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function editIncome() {
        var selectedId = getSelectedIncomeId();
        if (selectedId) {
            document.getElementById("incomeId").value = selectedId;
            // Populate form fields with selected income data
            var table = document.getElementById('incomeTable');
            var selectedRow;
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                var checkbox = row.cells[0].querySelector('input[type="checkbox"]');
                if (checkbox && checkbox.checked) {
                    selectedRow = row;
                    break;
                }
            }
                          if (selectedRow) {
                    document.getElementById('title').value = selectedRow.cells[2].innerText;
                    document.getElementById('description').value = selectedRow.cells[3].innerText;
                    document.getElementById('amount').value = selectedRow.cells[4].innerText;
                    document.getElementById('date').value = selectedRow.cells[5].innerText;
                    document.getElementById('category').value = selectedRow.cells[6].innerText;
                    document.getElementById('source').value = selectedRow.cells[7].innerText;
                }
            } else {
                alert("Please select an income entry to edit.");
            }
        }

        function getSelectedIncomeId() {
            var table = document.getElementById('incomeTable');
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                var checkbox = row.cells[0].querySelector('input[type="checkbox"]');
                if (checkbox && checkbox.checked) {
                    return row.cells[1].innerText;  // Returns the ID of the selected row
                }
            }
            return null;
        }

        function deleteSelected() {
            var table = document.getElementById('incomeTable');
            var checkboxes = document.querySelectorAll('input[name="incomeIds"]:checked');
            if (checkboxes.length === 0) {
                alert("Please select income entries to delete.");
                return;
            }
            var ids = [];
            checkboxes.forEach(function (checkbox) {
                ids.push(checkbox.value);
            });
            if (confirm("Are you sure you want to delete the selected entries?")) {
                // Send a request to the server to delete the selected incomes
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "../IncomeData", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        alert("Selected incomes deleted successfully.");
                        location.reload();
                    }
                };
                xhr.send("action=delete&ids=" + ids.join(","));
            }
        }

        function clearForm() {
            document.getElementById('incomeForm').reset();
            document.getElementById('incomeId').value = "";
        }
</script>
</body>
</html>

