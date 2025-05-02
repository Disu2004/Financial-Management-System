package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ExpenseServlet")
public class ExpenseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:mysql://localhost:3306/financial_data_system";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        double amount = Double.parseDouble(request.getParameter("amount"));
        Date date = Date.valueOf(request.getParameter("date"));
        String notes = request.getParameter("notes");

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            String sql = "INSERT INTO expenses (title, description, category, amount, date, notes) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            pstmt.setString(3, category);
            pstmt.setDouble(4, amount);
            pstmt.setDate(5, date);
            pstmt.setString(6, notes);
            pstmt.executeUpdate();
            pstmt.close();

            response.sendRedirect("ExpensePage.jsp"); // Redirect to expense page after successful insert
        } catch (SQLException e) {
            throw new ServletException("Error in adding expense to database", e);
        }
    }
}
