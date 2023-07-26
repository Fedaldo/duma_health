class Product {
  dynamic id, idCategory;
  bool prescription = false;
  String? name,
      description,
      regularPrice,
      price,
      quantity,
      image,
      idPharmacy,
      pharmacy;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    idCategory = json['pivot']['category_id'];
    prescription = isRequired(json);
    image = json['image'];
    idPharmacy = defaultValue(json, "id");
    pharmacy = defaultValue(json, "name");
    price = priceValue(json, "price");
    regularPrice = priceValue(json, "regular_price");
    quantity = priceValue(json, "quantity");
  }

  String defaultValue(Map<String, dynamic> json, String key) {
    return "${json['pharmacies'][0][key]}";
  }
  String priceValue(Map<String, dynamic> json, String key) {
    return "1000";
    //return "${json['pharmacies'][0]['pivot'][key]}";
  }

  bool isRequired(Map<String, dynamic> json) {
    if (json['prescription'] == "YES") {
      return true;
    }
    return false;
  }
}
