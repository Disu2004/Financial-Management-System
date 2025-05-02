<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Expense Categories</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .table-container {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .form-container {
            max-width: 400px;
            margin: auto;
            border: 1px solid #ddd;
            padding: 20px;
        }
        .form-container h2 {
            margin-bottom: 10px;
        }
        .form-container label {
            font-weight: bold;
        }
        .form-container input[type=text] {
            width: calc(100% - 20px);
            padding: 8px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-container input[type=submit] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .form-container input[type=submit]:hover {
            background-color: #45a049;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
    <script>
        function editExpenseCategory(id, title) {
            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = title;
        }

        function handleCheckboxClick(checkbox) {
            if (checkbox.checked) {
                var row = checkbox.closest('tr');
                var id = row.getAttribute('data-id');
                var title = row.cells[2].innerText.trim(); // Assuming title is in the third column

                document.getElementById('editCategoryId').value = id;
                document.getElementById('editCategoryName').value = title;
            } else {
                // Clear the input fields if no checkbox is checked
                document.getElementById('editCategoryId').value = '';
                document.getElementById('editCategoryName').value = '';
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h2>Manage Expense Categories</h2>
    </div>

    <div class="form-container">
        <h2>Add New Expense Category</h2>
        <form action="../ExpenseCategory" method="POST">
            <input type="hidden" name="action" value="add">
            <label for="categoryName">Category Name:</label>
            <input type="text" id="categoryName" name="categoryName" required>
            <br><br>
            <input type="submit" value="Add Category">
        </form>
    </div>

    <div class="form-container">
        <h2>Edit Expense Category</h2>
        <form action="../ExpenseCategory" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editCategoryId" name="categoryId">
            <label for="editCategoryName">Category Name:</label>
            <input type="text" id="editCategoryName" name="categoryName" required>
            <br><br>
            <input type="submit" value="Save">
        </form>
    </div>

    <div style="text-align: center;"><br><br>
        <form action="../ExpenseCategory" method="GET">
            <input type="hidden" name="action" value="delete">
            <input type="submit" value="Delete Selected" class="btn btn-danger"><br><br>
            <table id="expenseTable">
                <thead>
                    <tr>
                        <th>Select</th>
                        <th>ID</th>
                        <th>Title</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM expense_categories");

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String title = rs.getString("name");
                    %>
                    <tr data-id="<%= id %>">
                        <td><input type="checkbox" name="expenseIds" value="<%= id %>" onclick="handleCheckboxClick(this)"></td>
                        <td><%= id %></td>
                        <td><%= title %></td>
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
        </form>
    </div>

</body>
</html>
