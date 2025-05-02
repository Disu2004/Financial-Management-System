import java.io.IOException;
import java.sql.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IncomeCategory extends HttpServlet {

    private static final String url = "jdbc:mysql://localhost:3306/financial_data_system";
    private static final String user = "root";
    private static final String password = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryName = request.getParameter("categoryName");
        String query = "INSERT INTO income_categories (name) VALUES (?)";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, categoryName);
            stmt.executeUpdate();
            response.sendRedirect("/Financial_data_system/Frontend/IncomeCategory.jsp.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "true");
            request.getRequestDispatcher("/Frontend/IncomeCategory.jsp").forward(request, response);
        }
    }

    
}
