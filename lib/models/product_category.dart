class ProductCategory {
  dynamic id;
  String? name, description, image;

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['photo'];
  }
}