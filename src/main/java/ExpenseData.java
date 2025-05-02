import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class ExpenseData extends HttpServlet {

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
            response.sendRedirect("./Frontend/Expense.jsp");
            return;
        }

        switch (action) {
            case "add":
                addExpense(request);
                break;
            case "update":
                updateExpense(request);
                break;
            case "deleteSelected":
                deleteSelectedExpenses(request);
                break;
            default:
                response.sendRedirect("./Frontend/Expense.jsp");
                break;
        }

        response.sendRedirect("./Frontend/Expense.jsp");
    }

    private void addExpense(HttpServletRequest request) {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");

        String sql = "INSERT INTO expense (title, description, amount, date, category) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, title, description, amount, date, category);
    }

    private void updateExpense(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");

        String sql = "UPDATE expense SET title=?, description=?, amount=?, date=?, category=? WHERE id=?";
        jdbcTemplate.update(sql, title, description, amount, date, category, id);
    }

    private void deleteSelectedExpenses(HttpServletRequest request) {
        String[] selectedIds = request.getParameterValues("selectedIds");

        if (selectedIds != null && selectedIds.length > 0) {
            String sql = "DELETE FROM expense WHERE id=?";
            for (String id : selectedIds) {
                jdbcTemplate.update(sql, Integer.parseInt(id));
            }
        }
    }
}
