class ShippingDetails {
  String firstName, lastName, country, city, streetName;
  String? note;

  ShippingDetails(
      {required this.firstName,
        required this.lastName,
        required this.country,
        required this.city,
        required this.streetName,
        this.note});
}
