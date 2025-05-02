import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC URL, username, and password of MySQL server
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/";
    private static final String JDBC_USER = "your_username";
    private static final String JDBC_PASSWORD = "your_password";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String companyName = request.getParameter("name");

        // JDBC variables for opening, closing, and managing connection
        Connection conn = null;
        Statement stmt = null;

        try {
            // Open a connection
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Execute a query to create the new database
            System.out.println("Creating database for company: " + companyName);
            stmt = conn.createStatement();
            String sql = "CREATE DATABASE " + companyName;
            stmt.executeUpdate(sql);
            System.out.println("Database created successfully for company: " + companyName);

            // Redirect to a success page or handle as needed
            response.sendRedirect("success.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exceptions, redirect to an error page, etc.
        } finally {
            // Finally block to close resources
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
