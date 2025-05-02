<%-- 
    Document   : dashboard
    Created on : 24 Jun 2024, 3:25:08 pm
    Author     : nayan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
<!--    <link rel="stylesheet" type="text/css" href="<c:url value="/static/css/styles.css" />">-->
</head>
<body>
    <h2>Welcome to Your Dashboard</h2>
    <ul>
        <li><a href="<c:url value="/income" />">Income</a></li>
        <li><a href="<c:url value="/expenses" />">Expenses</a></li>
        <li><a href="<c:url value="/goals" />">Financial Goals</a></li>
    </ul>
    <!-- Additional content for displaying user information or summaries -->
</body>
</html>
