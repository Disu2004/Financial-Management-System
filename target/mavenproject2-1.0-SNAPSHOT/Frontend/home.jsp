<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expense Tracking System</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">

        <!-- Include Highcharts and its modules -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/data.js"></script>
        <script src="https://code.highcharts.com/modules/accessibility.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/modules/export-data.js"></script>
        <script src="https://code.highcharts.com/modules/series-label.js"></script>
        <script src="https://code.highcharts.com/modules/variable-pie.js"></script>
        <script src="https://code.highcharts.com/themes/dark-unica.js"></script>

        <!-- Inline JavaScript -->
        <script>
            function generatePieChart(reportType) {
                console.log("Generating pie chart for report type:", reportType);

                $.ajax({
                    url: '../ReportServlet',
                    type: 'GET',
                    data: {reportType: reportType},
                    success: function (response) {
                        console.log("Response from servlet:", response);

                        // Parse JSON response
                        var data = response;

                        // Prepare chartData array for Highcharts
                        var chartData = [];

                        // Add data points to chartData based on response
                        chartData.push({name: 'Income', y: data.totalIncome});
                        chartData.push({name: 'Expense', y: data.totalExpense});

                        // Calculate profit and loss (if needed)
                        var profit = data.profit;
                        var loss = data.loss;

                        // Update HTML elements with fetched data
                        $('#totalIncome').text(data.totalIncome.toFixed(2));
                        $('#totalExpense').text(data.totalExpense.toFixed(2));
                        $('#profit').text(profit.toFixed(2));
                        $('#loss').text(loss.toFixed(2));

                        // Render Highcharts pie chart
                        renderPieChart(reportType, chartData);
                    },
                    error: function (xhr, status, error) {
                        console.error('Error fetching report data:', error);
                    }
                });
            }

            function renderPieChart(reportType, chartData) {
                Highcharts.chart('pieChart', {
                    chart: {
                        type: 'pie'
                    },
                    title: {
                        text: reportType.charAt(0).toUpperCase() + reportType.slice(1) + ' Report'
                    },
                    series: [{
                            name: 'Amount',
                            colorByPoint: true,
                            data: chartData
                        }]
                });
            }

            function updateTimeAndDate() {
                var now = new Date();
                var hours = now.getHours();
                var minutes = now.getMinutes();
                var seconds = now.getSeconds();
                var day = now.getDate();
                var month = now.getMonth() + 1; // Months are zero-based
                var year = now.getFullYear();

                var timeString = (hours < 10 ? '0' : '') + hours + ':' +
                        (minutes < 10 ? '0' : '') + minutes + ':' +
                        (seconds < 10 ? '0' : '') + seconds;

                var dateString = (day < 10 ? '0' : '') + day + '-' +
                        (month < 10 ? '0' : '') + month + '-' + year;

                $('#clock').text(timeString);
                $('#date').text(dateString);
            }

            $(document).ready(function () {
                generatePieChart('daily'); // Initial chart load
                setInterval(updateTimeAndDate, 1000); // Update time and date every second
            });
            function navigateTo(page) {
                window.location.href = page + ".jsp";
            }
        </script>

    </head>
    <body>
        <div class="container-fluid">
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
                            <a class="nav-link" href="#" onclick="navigateTo('ExpenseCategoryPage')">Expense Category</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="navigateTo('IncomeCategoryPage')">Income Category</a>
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

            <div class="main-content">
                <div class="report-panel mx-auto">
                    <div class="title" id="reportType">Daily</div>
                    <div id="pieChart" style="height: 300px;"></div>
                    <div class="info-panel mt-4">
                        <div class="bg-dark text-white p-2 rounded">
                            <div>Total Income:</div>
                            <div id="totalIncome">0.0</div>
                        </div>
                        <div class="bg-dark text-white p-2 rounded">
                            <div>Total Expense:</div>
                            <div id="totalExpense">0.0</div>
                        </div>
                        <div class="bg-dark text-white p-2 rounded">
                            <div>Profit:</div>
                            <div id="profit">0.0</div>
                        </div>
                        <div class="bg-dark text-white p-2 rounded">
                            <div>Loss:</div>
                            <div id="loss">0.0</div>
                        </div>
                    </div>
                    <div class="report-buttons">
                        <button onclick="generatePieChart('daily')" class="btn btn-dark active">Daily</button>
                        <button onclick="generatePieChart('weekly')" class="btn btn-dark">Weekly</button>
                        <button onclick="generatePieChart('monthly')" class="btn btn-dark">Monthly</button>
                        <button onclick="generatePieChart('yearly')" class="btn btn-dark">Yearly</button>
                    </div>
                </div>
            </div>

            <div class="right-panel">
                <div class="clock" id="clock"></div>
                <div class="date" id="date"></div>
                <div class="about mt-4">
                    Expense Tracking System is a Java final project. This Expense Tracking System can be used for individual purpose and business purpose too. This software's main goal is to track income and expenses to increase savings.
                </div>
            </div>
        </div>
    </body>
</html>
