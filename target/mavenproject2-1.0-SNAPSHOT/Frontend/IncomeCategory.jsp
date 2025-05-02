<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Income Categories</title>
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
</head>
<body>
    <div class="header">
        <h2>Manage Income Categories</h2>
    </div>

    <div class="col-md-8">
            <table id="incomeTable" class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th></th>
                    <th>ID</th>
                    <th>Title</th>
                    
                </tr>
                </thead>
                <tbody id="incomeTableBody">
                <% 
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM income_categories");

                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String title = rs.getString("name");
                            
                %>
                <tr id="row-<%= id%>">
                    <td><input type="checkbox" name="incomeIds" value="<%= id%>"></td>
                    <td><%= id%></td>
                    <td><%= title%></td>
                    
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

    <div class="form-container">
        <h2>Add New Income Category</h2>
        <form action="../IncomeCategory" method="POST">
          
            <label for="categoryName">Category Name:</label>
            <input type="text" id="categoryName" name="categoryName" required>
            <br><br>
            <input type="submit" value="Add Category">
            <c:if test="${error eq 'true'}">
                
            </c:if>
        </form>
    </div>

    <div style="text-align: center;">
        <a href="./index.jsp">Back</a>
    </div>
</body>
</html>
