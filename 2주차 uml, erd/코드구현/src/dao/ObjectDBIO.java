package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import lombok.Data;

@Data
public class ObjectDBIO {
  private String MYSQL_DRIVER;
  private String MYSQL_URL = "jdbc:mysql://localhost:3306/wms";
  private String MYSQL_ID;
  private String MYSQL_PW;

  public static void startWMS() {
    String query = "CREATE table ? (id unsigned auto_increment not null, name varchar(20) not null, location varchar(50) not null, contact varchar(20) not null, capacity int not null, type varchar(50), manager varchar(20) not null);";
  }

  public Connection open() {
    try {
      Connection connection = DriverManager.getConnection(MYSQL_URL, MYSQL_ID, MYSQL_PW);
      return connection;
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public void close(Connection connection) {
    try {
      connection.close();
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }
}
