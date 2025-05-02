import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserRegister extends HttpServlet {

    // JDBC URL, username, and password of MySQL server
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Read parameters from the request
        String companyName = request.getParameter("name");

        PrintWriter out = response.getWriter();

        // JDBC variables for opening, closing, and managing connection
        Connection conn = null;
        Statement stmt = null;

        try {
            // Register JDBC driver - this step may not be necessary depending on your environment
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Open a connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Execute a query to create the new database
            stmt = conn.createStatement();
            String sql = "CREATE DATABASE IF NOT EXISTS " + companyName; // Check if database exists
            stmt.executeUpdate(sql);

            // Print registration success message with the database created
            out.println("<html><head><title>Registration Successful</title></head><body>");
            out.println("<h2>Registration Successful</h2>");
            out.println("<p>Database created for company: " + companyName + "</p>");
            out.println("</body></html>");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Database error: " + e.getMessage());
        } finally {
            // Close resources in a finally block
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            out.close(); // Close PrintWriter
        }
    }

    @Override
    public String getServletInfo() {
        return "User Registration Servlet";
    }
}
