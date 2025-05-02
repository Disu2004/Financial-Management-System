<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <a class="navbar-brand" href="#">Expense Tracking System</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('home')">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('Expense')">Expense</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('Income')">Income</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('ExpenseCategory')">Expense Category</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('IncomeCategory')">Income Category</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('ReportPage')">Report</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="navigateTo('LoginPage')">Sign out</a>
            </li>
        </ul>
    </div>
</nav>

<script>
    function navigateTo(page) {
        window.location.href = page + ".jsp";
    }
</script>
