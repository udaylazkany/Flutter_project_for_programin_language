import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';
import '../view/screen/AddApartmentPage.dart';
import '../view/screen/ConversationsPage.dart';
import '../view/screen/login.dart';

class HomeController extends GetxController {
  final Crud api = Crud();
  final storage = const FlutterSecureStorage();

  // ===========================
  // Reactive State
  // ===========================
  RxBool isLoading = true.obs;

  // ===========================
  // User Info
  // ===========================
  String? role;
  String? userId;

  bool get isOwner => (role ?? "") == "owner";

  // ===========================
  // Data Lists
  // ===========================
  List apartments = [];
  List addresses = [];

  List myApartmentsList = [];
  List myAddressesList = [];

  List myBookingApartments = [];
  List myBookingAddresses = [];

  bool _isLoadingNow = false;

  // ===========================
  // Lifecycle
  // ===========================
  @override
  void onInit() {
    super.onInit();
    loadData();

  }

  // ===========================
  // Load All Data
  // ===========================
  Future<void> loadData() async {
    if (_isLoadingNow) return;
    _isLoadingNow = true;

    try {
      isLoading.value = true;

      await _loadUserInfo();
      await _loadApartments();
      await _loadMyApartments();
      await _loadMyBookings();

    } catch (e) {
      print("ERROR LOADING DATA: $e");
    } finally {
      _isLoadingNow = false;
      isLoading.value = false;
      update();
    }
  }

  // ===========================
  // Load User Info
  // ===========================
  Future<void> _loadUserInfo() async {
    role = await storage.read(key: "role");
    userId = await storage.read(key: "userId");
  }

  // ===========================
  // Load All Apartments (Public)
  // ===========================
  Future<void> _loadApartments() async {
    var response = await api.getRequest(linkeViewAppartment);

    apartments = response["data"]["Appartment"] ?? [];
    addresses = response["data"]["Apartment_Address"] ?? [];
  }

  // ===========================
  // Load My Apartments (Owner)
  // ===========================
  Future<void> _loadMyApartments() async {
    var response = await api.getRequest(linkeViewmyAppartment);

    myApartmentsList = response["data"]["Appartment"] ?? [];
    myAddressesList = response["data"]["Apartment_Address"] ?? [];
  }

  // ===========================
  // Load My Bookings (Tenant)
  // ===========================
  Future<void> _loadMyBookings() async {
    var response = await api.getRequest(linkemycontracts);

    myBookingApartments = [];
    myBookingAddresses = [];

    if (response["data"]?["contracts"] != null) {
      for (var contract in response["data"]["contracts"]) {
        if (contract["apartment"] != null) {
          myBookingApartments.add(contract["apartment"]);
        }
      }
    }

    for (var apt in myBookingApartments) {
      final address = addresses.firstWhere(
            (a) => a['id'] == apt['adress_Id'],
        orElse: () => null,
      );

      if (address != null) {
        myBookingAddresses.add(address);
      }
    }
  }

  // ===========================
  // Refresh All Data
  // ===========================
  Future<void> refreshPage() async {
    await loadData();
  }

  // ===========================
  // Helpers
  // ===========================
  Map<String, dynamic> getAddressForApartment(Map apt) {
    return addresses.firstWhere(
          (a) => a['id'] == apt['adress_Id'],
      orElse: () => {},
    );
  }

  String getImageUrl(String? image) {
    return image == null
        ? "https://via.placeholder.com/300"
        : "$linkeserverName/storage/apartments/$image";
  }

  String formatDate(String? date) {
    if (date == null) return "";
    return date.split("T").first;
  }

  // ===========================
  // UI Actions
  // ===========================
  void toggleLanguage() {
    if (Get.locale!.languageCode == 'ar') {
      Get.updateLocale(const Locale('en'));
    } else {
      Get.updateLocale(const Locale('ar'));
    }
  }

  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
  void goToConversations(int currentUserId) {
    Get.to(() => ConversationsPage(currentUserId: currentUserId));
  }



  // ===========================
  // Logout
  // ===========================
  Future<void> logout(BuildContext context) async {
    var response = await api.postRequest(linkelogout, {});

    if (response != null && response['status'] == true) {
      await storage.delete(key: "token");
      await storage.delete(key: "userId");
      await storage.delete(key: "tenantId");

      Get.deleteAll(force: true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Get.snackbar("Error", "Logout failed");
    }
  }

  Future<void> addApartment(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddApartmentPage()),
    );
  }
}