class Insurance {
  dynamic id;
  String? name, image;
  late bool isSelected;

  Insurance({this.id, this.name, this.image,this.isSelected = false});

  Insurance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['photo'];
    isSelected = false;
  }
}