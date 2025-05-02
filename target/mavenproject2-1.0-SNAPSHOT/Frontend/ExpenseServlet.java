package Frontend;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ExpenseServlet")
public class ExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            addExpense(request, response);
        } else {
            switch (action) {
                case "add":
                    addExpense(request, response);
                    break;
                case "update":
                    updateExpense(request, response);
                    break;
                case "delete":
                    deleteExpense(request, response);
                    break;
                default:
                    addExpense(request, response);
                    break;
            }
        }
    }

    private void addExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");
        String notes = request.getParameter("notes");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
            PreparedStatement ps = conn.prepareStatement("INSERT INTO expense (title, description, amount, date, category, notes) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setDouble(3, amount);
            ps.setString(4, date);
            ps.setString(5, category);
            ps.setString(6, notes);
            
            ps.executeUpdate();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("Expense.jsp");
    }

    private void updateExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");
        String category = request.getParameter("category");
        String notes = request.getParameter("notes");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
            PreparedStatement ps = conn.prepareStatement("UPDATE expense SET title = ?, description = ?, amount = ?, date = ?, category = ?, notes = ? WHERE id = ?");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setDouble(3, amount);
            ps.setString(4, date);
            ps.setString(5, category);
            ps.setString(6, notes);
            ps.setInt(7, id);
            
            ps.executeUpdate();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("Expense.jsp");
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/financial_data_system", "root", "");
            PreparedStatement ps = conn.prepareStatement("DELETE FROM expense WHERE id = ?");
            ps.setInt(1, id);
            
            ps.executeUpdate();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("Expense.jsp");
    }

    private void clearForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Expense.jsp");
    }
}
