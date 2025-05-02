
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class IncomeData extends HttpServlet {

    private JdbcTemplate jdbcTemplate;

    @Override
    public void init() throws ServletException {
        // Set up the DataSource and JdbcTemplate
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Update these variables with your actual database credentials
        String url = "jdbc:mysql://localhost:3306/financial_data_system";
        String username = "root";
        String password = "";

        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);

        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect("./Frontend/Income.jsp");
            return;
        }

        switch (action) {
            case "add":
                addIncome(request);
                break;
            case "update":
                updateIncome(request);
                break;
            case "deleteSelected":
                deleteSelectedIncome(request);
                break;
            default:
                response.sendRedirect("./Frontend/Income.jsp");
                break;
        }

        response.sendRedirect("./Frontend/Income.jsp");
    }

    private void addIncome(HttpServletRequest request) {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");
        String source = request.getParameter("source");

        String sql = "INSERT INTO income (title, description, amount, date, category, source) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, title, description, amount, date, category, source);
    }

    private void updateIncome(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");
        String source = request.getParameter("source");

        String sql = "UPDATE income SET title=?, description=?, amount=?, date=?, category=?, source=? WHERE id=?";
        jdbcTemplate.update(sql, title, description, amount, date, category, source, id);
    }

   private void deleteSelectedIncome(HttpServletRequest request) {
    String[] selectedIds = request.getParameterValues("selectedIds");

    if (selectedIds != null && selectedIds.length > 0) {
        String sql = "DELETE FROM income WHERE id=?";
        for (String id : selectedIds) {
            try {
                int deleted = jdbcTemplate.update(sql, Integer.parseInt(id));
                System.out.println("Deleted rows: " + deleted);
            } catch (Exception e) {
                System.err.println("Error deleting income with ID " + id + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}

}

