package dto.warehouse;

import dto.client.Client;
import java.util.Date;
import lombok.Data;

@Data
public class Inventory {
  private String inventoryId;
  private WhSection section;
  private Date storedDate;
  private Client in_charge;
  private String reference;
}
