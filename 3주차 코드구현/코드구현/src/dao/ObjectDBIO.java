package dao;

import static vo.WMSMenu.showMenu;

import com.mysql.cj.x.protobuf.MysqlxPrepare.Prepare;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import lombok.Data;

@Data
public class ObjectDBIO {
  private static String MYSQL_URL = "jdbc:mysql://localhost:3306/wms";
  private static String MYSQL_ID = "smoofi";
  private static String MYSQL_PW = "smoofi";
  private static Connection connection;
  private static PreparedStatement pstmt;


  public static void startWMS() {
    open();
    showMenu();
    close(connection);
  }

  public static void executeQuery(String query) {
    try {
      pstmt = connection.prepareStatement(query);
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static Connection open() {
    try {
      return DriverManager.getConnection(MYSQL_URL, MYSQL_ID, MYSQL_PW);
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static void close(Connection connection) {
    try {
      connection.close();
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }
}
