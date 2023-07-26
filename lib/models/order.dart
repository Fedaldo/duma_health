class Order {
  dynamic id,
      itemsTotal,
      deliveryFees,
      currencyId,
      paymentMethodId,
      statusId,
      userId,
      amountTotal;
  String? reference,
      afripayClientToken,
      paymentMethod,
      status,
      username,
      dateCreated;
  OrderShipping shipping = OrderShipping();
  OrderInsurance? insurance;
  List<OrderProduct> products = [];

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsTotal = json['items_total'];
    amountTotal = json['amount_total'];
    reference = json['order_reference'];
    shipping = OrderShipping.fromJson(json['shipping_address']);
    if(json['insurance'] != null){
      insurance = OrderInsurance.fromJson(json['insurance']);
    }
    deliveryFees = json['shipping_fees'];
    afripayClientToken = json['afripay_client_token'];
    currencyId = json['currency_id'];
    paymentMethodId = json['payment_method_id'];
    paymentMethod = json['payment_method_name'];
    statusId = json['status_id'];
    status = json['status_name'];
    userId = json['user_id'];
    username = json['user_name'];
    products = (json['products'] as List)
        .map(
          (e) => OrderProduct.fromJson(e),
        )
        .toList();
    dateCreated = json['date_created'];
  }
}

class OrderShipping {
  String? firstName, lastName, city, district, note;

  OrderShipping();

  OrderShipping.fromJson(Map<String, dynamic> json) {
    firstName = json['shipping_first_name'];
    lastName = json['shipping_last_name'];
    city = json['shipping_city'];
    district = json['shipping_district'];
    note = json['shipping_note'];
  }
}

class OrderProduct {
  dynamic id, quantity, price, pharmacyId, statusId;
  String? prescription, name, pharmacy, status;

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['medicament_id'];
    quantity = json['quantity'];
    price = json['price'];
    prescription = json['prescription'];
    pharmacyId = json['pharmacy_id'];
    pharmacy = json['pharmacy_name'];
    name = json['medicament_name'];
    statusId = json['status_id'];
    status = json['status_name'];
  }
}

class OrderInsurance {
  dynamic id, percentage, amount;

  OrderInsurance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    percentage = json['percentage'];
    amount = json['amount'];
  }
}
