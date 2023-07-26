class CartProduct {
  String phId;
  int? id, qty, stockQuantity;
  String name, price;
  String? regularPrice;
  int total;
  String? prescription;

  CartProduct(
      {required this.id,
        required this.phId,
        required this.name,
        this.regularPrice,
        required this.price,
        required this.qty,
        this.stockQuantity,
        this.prescription,
        required this.total});
}
