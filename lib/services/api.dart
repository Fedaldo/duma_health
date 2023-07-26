import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:duma_health/models/appointment.dart';
import 'package:duma_health/models/chat_message.dart';
import 'package:duma_health/models/country.dart';
import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/insurance.dart';
import 'package:duma_health/models/order.dart';
import 'package:duma_health/models/product.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/models/user.dart';
import 'package:flutter/material.dart';

class Api {
  static String baseUrl = "https://www.pesabay.bi/doctor/api/admin";

  static Dio certificateOverride(){
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }
  static Future<List<Hospital>> getHospitals() async {
    List<Hospital> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/list-hospitals",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data as List)
            .map(
              (e) => Hospital.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<List<Doctor>> getDoctors(String serviceId) async {
    List<Doctor> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/list-doctors-by-service/$serviceId",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data[0]['doctors'] as List)
            .map(
              (e) => Doctor.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<User> login(var data) async {
    late User user;
    try {
      var res = await certificateOverride().post(
        "https://www.pesabay.bi/doctor/api/login",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        user = User.fromJson(res.data);
      } else {
        user = User(error: "Wrong Credentials");
      }
    } on DioError catch (e) {
      debugPrint("$e");
      user = User(error: "Wrong Credentials");
    }
    return user;
  }

  static Future<User> signUp(var data) async {
    late User user;
    try {
      var res = await certificateOverride().post(
        "$baseUrl/add-user",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        var loginData = {
          "email": data['email'],
          "password": data['password'],
        };
        await login(loginData).then((value) {
          user = value;
          return user;
        });
      } else {
        user = User(error: "User already exists in our system. If not, please contact us for support.");
      }
    } on DioError catch (e) {
      debugPrint("$e");
      user = User(error: "User already exists in our system. If not, please contact us for support.");
    }
    return user;
  }

  static Future<Appointment?> requestAppointment(var data) async {
    try {
      var res = await certificateOverride().post(
        "$baseUrl/add-appointment",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        Appointment appointment =
            Appointment.fromJson(res.data['last_appointment']);
        return appointment;
      }
      return null;
    } on DioError catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  static Future<List<Appointment>> getAppointments(
      {required String userId}) async {
    List<Appointment> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/userAppointments/$userId",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data['data'] as List)
            .map(
              (e) => Appointment.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<List<ProductCategory>> getCategories() async {
    List<ProductCategory> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/listCategories",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data['data'] as List)
            .map(
              (e) => ProductCategory.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<List<Country>> getCountries() async {
    List<Country> prods = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/list-countries",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        prods = (res.data['data'] as List)
            .map(
              (e) => Country.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return prods;
  }

  static Future<List<Insurance>> getInsurances() async {
    List<Insurance> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/list-insurances",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data['data'] as List)
            .map(
              (e) => Insurance.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<List<Product>> productsCategory(String categoryId) async {
    List<Product> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/show-medicaments/$categoryId",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (res.statusCode == 200) {
        data = (res.data as List)
            .map(
              (e) => Product.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<Order?> createOrder(var data) async {
    try {
      var res = await certificateOverride().post(
        "$baseUrl/store-order",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        return Order.fromJson(res.data['data']);
      } else {
        return null;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  static Future<List<Order>> orders({required String userId}) async {
    List<Order> data = [];
    try {
      var res = await certificateOverride().get(
        "$baseUrl/user-orders/$userId",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        data = (res.data['data'] as List)
            .map(
              (e) => Order.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<bool> updateOrder(String id) async {
    try {
      var res = await certificateOverride().patch(
        "$baseUrl/update-order/$id",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  static Future<List<ChatMessage>> chats({required String userId}) async {
    List<ChatMessage> data = [];
    String lastId = "0";
    try {
      var res = await certificateOverride().get(
        "$baseUrl/sender-chats/$userId",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        List results = res.data['data'] as List;
        if (results.isNotEmpty) {
          List<ChatMessage> chats = [];
          for (var r in results) {
            ChatMessage chatMessage = ChatMessage(
                text: "${r['chat']}",
                date: "${r['created_at']}",
                id: "${r['id']}",
                messageStatus: MessageStatus.viewed,
                isSender: userId == "${r['sender_id']}" ? true : false);
            chats.add(chatMessage);
          }
          if (chats.last.id != lastId) {
            lastId = chats.last.id;
            data = chats;
          }
        }
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return data;
  }

  static Future<ChatMessage> sendChat(
      ChatMessage errorMessage, var data) async {
    try {
      var res = await certificateOverride().post(
        "$baseUrl/chats",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        return ChatMessage(
            text: "${res.data['data']['chat']}",
            date: "${res.data['data']['created_at']}",
            id: "${res.data['data']['id']}",
            messageStatus: MessageStatus.viewed,
            isSender: true);
      } else {
        return errorMessage;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return errorMessage;
  }
}
