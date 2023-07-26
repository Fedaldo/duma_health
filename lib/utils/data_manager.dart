import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/models/order.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/models/shipping_details.dart';

class DataManager {
  static final DataManager _ourInstance = DataManager();
  String? date;
  HospitalService? service;
  Hospital? hospital;
  ProductCategory? currentCategory;
  ShippingDetails? shippingDetails;

  Order? currentOrder;

  static DataManager getInstance() {
    return _ourInstance;
  }
}
