import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class CreateDatabase {

    // JDBC URL, username, and password of MySQL server
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter the name for the new database: ");
        String dbName = scanner.nextLine().trim();

        // JDBC variables for opening, closing, and managing connection
        Connection conn = null;
        Statement stmt = null;

        try {
            // Open a connection
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Execute a query to create the new database
            System.out.println("Creating database...");
            stmt = conn.createStatement();
            String sql = "CREATE DATABASE " + dbName;
            stmt.executeUpdate(sql);
            System.out.println("Database created successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Finally block to close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
