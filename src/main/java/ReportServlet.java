import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportType = request.getParameter("reportType");
        LocalDate startDate = null;
        LocalDate endDate = LocalDate.now();

        switch (reportType) {
            case "daily":
                startDate = LocalDate.now();
                break;
            case "weekly":
                startDate = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
                break;
            case "monthly":
                startDate = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
                break;
            case "yearly":
                startDate = LocalDate.now().withDayOfYear(1);
                break;
            default:
                // Handle invalid report type
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type");
                return;
        }

        // Fetch data from database
        double totalIncome = getTotalAmount("income", startDate, endDate);
        double totalExpense = getTotalAmount("expense", startDate, endDate);
        double profit = totalIncome - totalExpense;
        double loss = totalExpense > totalIncome ? totalExpense - totalIncome : 0;

        // Prepare response data
        ReportData reportData = new ReportData(totalIncome, totalExpense, profit, loss);
        Gson gson = new Gson();
        String jsonData = gson.toJson(reportData);

        // Set response type and write data
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write(jsonData);
    }

    private double getTotalAmount(String tableName, LocalDate startDate, LocalDate endDate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        double totalAmount = 0.0;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection to MySQL database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");

            // Query to fetch total amount
            String query = "SELECT SUM(amount) AS totalAmount FROM " + tableName + " WHERE date >= ? AND date <= ?";
            stmt = conn.prepareStatement(query);
            stmt.setDate(1, java.sql.Date.valueOf(startDate));
            stmt.setDate(2, java.sql.Date.valueOf(endDate));
            rs = stmt.executeQuery();

            // Process result set
            if (rs.next()) {
                totalAmount = rs.getDouble("totalAmount");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Close JDBC resources in finally block
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return totalAmount;
    }

    // Class to hold report data
    private static class ReportData {
        private double totalIncome;
        private double totalExpense;
        private double profit;
        private double loss;

        public ReportData(double totalIncome, double totalExpense, double profit, double loss) {
            this.totalIncome = totalIncome;
            this.totalExpense = totalExpense;
            this.profit = profit;
            this.loss = loss;
        }
    }
}
