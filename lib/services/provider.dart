import 'package:duma_health/models/appointment.dart';
import 'package:duma_health/models/chat_message.dart';
import 'package:duma_health/models/country.dart';
import 'package:duma_health/models/insurance.dart';
import 'package:duma_health/models/order.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  dynamic get uDetails => _userDetails;
  dynamic _userDetails;

  setUserDetails(dynamic user) {
    _userDetails = user;
    notifyListeners();
  }

  List<Hospital> _hospitals = [];

  List<Hospital> get hospitals => List.from(_hospitals);

  List<Doctor> _doctors = [];

  List<Doctor> get doctors => List.from(_doctors);

  List<Country> _countries = [];

  List<Country> get countries => List.from(_countries);

  List<Insurance> _insurances = [];

  List<Insurance> get insurances => List.from(_insurances);

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getHospitals() async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      await Api.getHospitals().then((values) {
        _hospitals = values;
      });
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  getDoctors(String serviceId) async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      await Api.getDoctors(serviceId).then((values) {
        _doctors = values;
      });
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  getCountries() async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      await Api.getCountries().then((values) {
        _countries = values;
      });
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  getInsurances() async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      await Api.getInsurances().then((values) {
        _insurances = values;
      });
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  void checkError(e) {
    if (Utils.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.from(_appointments);

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getAppointments({String? userId}) async {
    if (userId != null) {
      setApiRequestStatus(APIRequestStatus.loading);
      try {
        await Api.getAppointments(userId: userId).then((values) {
          _appointments = values;
        });
        setApiRequestStatus(APIRequestStatus.loaded);
      } catch (e) {
        checkError(e);
      }
    } else {
      _appointments = [];
      setApiRequestStatus(APIRequestStatus.loaded);
    }
  }

  void sortByInDate() {
    _appointments.sort(
      (a, b) => a.date!.compareTo(b.date!),
    );
    notifyListeners();
  }

  void sortByDisDate() {
    _appointments.sort(
      (a, b) => b.date!.compareTo(a.date!),
    );
    notifyListeners();
  }

  void sortByDoctor() {
    _appointments.sort(
      (a, b) => b.doctor!.compareTo(a.doctor!),
    );
    notifyListeners();
  }

  void checkError(e) {
    if (Utils.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}

class CategoryProvider extends ChangeNotifier {
  List<ProductCategory> _categories = [];

  List<ProductCategory> get categories => List.from(_categories);

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getCategories() async {
    setApiRequestStatus(APIRequestStatus.loading);
    try {
      await Api.getCategories().then((values) {
        _categories = values;
      });
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  void checkError(e) {
    if (Utils.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => List.from(_orders);

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getOrders({String? userId}) async {
    if (userId != null) {
      setApiRequestStatus(APIRequestStatus.loading);
      try {
        await Api.orders(userId: userId).then((values) {
          _orders = values;
        });
        setApiRequestStatus(APIRequestStatus.loaded);
      } catch (e) {
        checkError(e);
      }
    } else {
      _orders = [];
      setApiRequestStatus(APIRequestStatus.loaded);
    }
  }

  void sortByInDate() {
    _orders.sort(
      (a, b) => b.reference!.compareTo(a.reference!),
    );
    notifyListeners();
  }

  void sortByOutDate() {
    _orders.sort(
      (a, b) => a.reference!.compareTo(b.reference!),
    );
    notifyListeners();
  }

  void sortByStatus() {
    _orders.sort(
      (a, b) => b.statusId!.compareTo(a.statusId!),
    );
    notifyListeners();
  }

  void sortByAmount() {
    _orders.sort(
      (a, b) => b.amountTotal!.compareTo(a.amountTotal!),
    );
    notifyListeners();
  }

  void checkError(e) {
    if (Utils.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _chats = [];

  List<ChatMessage> get chats => List.from(_chats);

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getChats(String time, {String? userId}) async {
    List<ChatMessage> defaultMessage = [
      ChatMessage(
          text: "Hey ✋🏽 it's Duma Health, How can we help you?",
          date: time,
          id: "0",
          messageStatus: MessageStatus.viewed,
          isSender: false),
    ];
    if (userId != null) {
      setApiRequestStatus(APIRequestStatus.loading);
      try {
        await Api.chats(userId: userId).then((values) {
          _chats = defaultMessage + values;
        });
        setApiRequestStatus(APIRequestStatus.loaded);
      } catch (e) {
        checkError(e);
      }
    } else {
      _chats = defaultMessage;
      setApiRequestStatus(APIRequestStatus.loaded);
    }
  }

  addChat(ChatMessage chatMessage) {
    _chats.add(chatMessage);
    notifyListeners();
  }
  deleteChat(ChatMessage chatMessage) {
    _chats.remove(chatMessage);
    notifyListeners();
  }

  void checkError(e) {
    if (Utils.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}
