import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PieChart {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/PieChart")
    public ReportData getReportData(@RequestParam("reportType") String reportType) {
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
                throw new IllegalArgumentException("Invalid report type: " + reportType);
        }

        double totalIncome = getTotalAmount("income", startDate, endDate);
        double totalExpense = getTotalAmount("expense", startDate, endDate);
        double profit = totalIncome - totalExpense;
        double loss = totalExpense > totalIncome ? totalExpense - totalIncome : 0;

        return new ReportData(totalIncome, totalExpense, profit, loss);
    }

    private double getTotalAmount(String tableName, LocalDate startDate, LocalDate endDate) {
        String query = "SELECT COALESCE(SUM(amount), 0) AS totalAmount FROM " + tableName + " WHERE date >= ? AND date <= ?";
        return jdbcTemplate.queryForObject(query, Double.class, java.sql.Date.valueOf(startDate), java.sql.Date.valueOf(endDate));
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

        // Getters (optional, depending on usage)
        public double getTotalIncome() {
            return totalIncome;
        }

        public double getTotalExpense() {
            return totalExpense;
        }

        public double getProfit() {
            return profit;
        }

        public double getLoss() {
            return loss;
        }
    }
}
