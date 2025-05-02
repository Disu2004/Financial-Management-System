import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExpenseCategory extends HttpServlet {

    private static final String url = "jdbc:mysql://localhost:3306/financial_data_system";
    private static final String user = "root";
    private static final String password = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String categoryName = request.getParameter("categoryName");

        if ("add".equals(action)) {
            addCategory(categoryName, request, response);
        } else if ("update".equals(action)) {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            updateCategory(categoryId, categoryName, request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    deleteCategory(categoryId, request, response);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Invalid categoryId");
                    request.getRequestDispatcher("/Frontend/ExpenseCategory.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "categoryId is null or empty");
                request.getRequestDispatcher("/Frontend/ExpenseCategory.jsp").forward(request, response);
            }
        }
    }

    private void addCategory(String categoryName, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = "INSERT INTO expense_categories (name) VALUES (?)";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, categoryName);
            stmt.executeUpdate();
            response.sendRedirect("/Financial_data_system/Frontend/ExpenseCategory.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/Frontend/ExpenseCategory.jsp").forward(request, response);
        }
    }

    private void updateCategory(int categoryId, String categoryName, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = "UPDATE expense_categories SET name = ? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, categoryName);
            stmt.setInt(2, categoryId);
            stmt.executeUpdate();
            response.sendRedirect("/Financial_data_system/Frontend/ExpenseCategory.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/Frontend/ExpenseCategory.jsp").forward(request, response);
        }
    }

    private void deleteCategory(int categoryId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = "DELETE FROM expense_categories WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, categoryId);
            stmt.executeUpdate();
            response.sendRedirect("/Financial_data_system/Frontend/ExpenseCategory.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/Frontend/ExpenseCategory.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Expense Category Servlet";
    }
}
