package dto.warehouse;

import lombok.Data;

@Data
public class Warehouse {
  private Long id;
  private String name;
  private String location;
  private String contact;
  private int capacity;
  private String type;
  private Client manager;
}
