package dao.warehouse;

import dao.ObjectDBIO;
import dto.warehouse.Warehouse;
import java.sql.Connection;

public class WarehouseDao extends ObjectDBIO {

  @Override
  public Connection open() {
    return super.open();
  }

  @Override
  public void close(Connection connection) {
    super.close(connection);
  }

  public boolean registerWh() {
    String query =
    return true;
  }

  public Warehouse readWh() {

  }
}
