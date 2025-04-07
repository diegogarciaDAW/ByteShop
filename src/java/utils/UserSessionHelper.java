package utils;

import java.sql.*;

public class UserSessionHelper {

    public static String getActiveUsername(Connection connection) throws SQLException {
        String username = null;
        String sql = "SELECT user FROM login WHERE idEstado=1 LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                username = rs.getString("user");
            }
        }
        return username;
    }

    public static int getActiveUserRole(Connection connection) throws SQLException {
        String sql = "SELECT Rol FROM login WHERE idEstado=1 LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("Rol");
            } else {
                return -1; // No hay usuario activo
            }
        }
    }

    public static boolean isUserLoggedIn(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM login WHERE idEstado=1";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }
}
