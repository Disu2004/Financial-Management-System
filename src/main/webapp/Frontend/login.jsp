<%-- 
    Document   : login
    Created on : 24 Jun 2024, 3:24:41 pm
    Author     : nayan
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
<!--    <link rel="stylesheet" type="text/css" href="<c:url value="/static/css/styles.css" />">-->
</head>
<body>
    <h2>Login</h2>
    <form action="<c:url value="/login" />" method="post">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
