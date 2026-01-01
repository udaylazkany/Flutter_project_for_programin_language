import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApartmentDetailsController extends GetxController {
  // 🔹 أدوات أساسية
  final Crud crud = Crud();
  final storage = const FlutterSecureStorage();
  var apartments = <Map<String, dynamic>>[].obs; // قائمة الشقق
  var addresses = <Map<String, dynamic>>[].obs;  // قائمة العناوين

  // 🔹 الحالة العامة للشقة
  var status = "loading".obs;
  var tenantId = 0.obs;
  var contractId = 0.obs;
  var currentTenantId = 0.obs;
  var ownerId = 0.obs;
  var contractStatus = "".obs;

  // 🔹 التواريخ
  var startDate = "".obs;
  var endDate = "".obs;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCurrentTenantId();
  }

  // 🔹 تحميل userId من التخزين الآمن
  Future<void> loadCurrentTenantId() async {
    String? id = await storage.read(key: "userId");
    currentTenantId.value = int.tryParse(id ?? "0") ?? 0;
  }

  // 🔹 تحميل حالة الشقة من السيرفر
  Future<void> loadApartmentStatus(int apartmentId) async {
    var response = await crud.getRequest(
      linkeViewcontractStatus(apartmentId),
    );
    print("reererre $response");
    if (response["status"] == 200 || response["status"] == 201) {
      status.value = response["data"]["statusApartments"] ?? "unknown";
      tenantId.value = response["data"]["tenant_id"] ?? 0;
      contractId.value = response["data"]["contract_id"] ?? 0;
      ownerId.value = response["data"]["owner_id"] ?? 0;
      contractStatus.value = response["data"]["contract_status"] ?? "unknown";
    } else {
      status.value = "unknown";
      contractStatus.value = "unknown";
    }
  }

  // 🔹 اختيار تاريخ البداية
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      startDate.value = "${date.year}-${date.month}-${date.day}";
      startDateController.text = startDate.value;
    }
  }

  // 🔹 اختيار تاريخ النهاية
  Future<void> pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      endDate.value = "${date.year}-${date.month}-${date.day}";
      endDateController.text = endDate.value;
    }
  }

  // 🔹 حجز الشقة
  Future<void> bookApartment(int apartmentId) async {
    final body = {
      "apartment_id": apartmentId,
      "tenant_id": currentTenantId.value,
      "rent_start": startDate.value,
      "rent_end": endDate.value,
      "contractsstatus": "waiting approve"
    };

    await crud.postRequest(linkecontractsbook, body);

    status.value = "rented";
    tenantId.value = currentTenantId.value;
  }

  // 🔹 إلغاء الحجز
  Future<void> cancelBooking(int apartmentId) async {
    final body = {
      "contract_id": contractId.value,
    };

    var response = await crud.postRequest(linkecontractsCancel, body);

    if (response["status"] == 200) {
      // المالك هو من ألغى العقد
      status.value = "vacant";
      contractStatus.value = "cancelled";
      tenantId.value = 0; // ← أهم تعديل

      Get.snackbar(
        "نجاح",
        "تم إلغاء العقد وتحرير الشقة",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    else if (response["status"] == 201) {
      // المستأجر طلب إلغاء العقد
      contractStatus.value = "waiting cancel";

      Get.snackbar(
        "تم إرسال الطلب",
        "بانتظار موافقة المالك",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل إلغاء الحجز",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    // تحديث حالة الشقة بعد العملية
    await loadApartmentStatus(apartmentId);
  } // 🔹 تعديل الحجز
  Future<void> updateBooking(int apartmentId) async {
    final body = {
      "contract_id": contractId.value,
      "tenant_id": currentTenantId.value,
      "rent_start": startDate.value,
      "rent_end": endDate.value,
    };

    await crud.postRequest(linkecontractsUpdate, body);
  }

  /// تحميل كل الشقق والعناوين من الـ API الجديد
  Future<void> loadAllApartments() async {
    try {
      var response = await crud.getRequest(linkeviewall);

      if (response["status"] == 200) {
        apartments.value = List<Map<String, dynamic>>.from(response["data"]["Appartment"] ?? []);
        addresses.value = List<Map<String, dynamic>>.from(response["data"]["Apartment_Address"] ?? []);
        print("✅ تم تحميل الشقق (${apartments.length}) والعناوين (${addresses.length})");
      } else {
        print("❌ فشل تحميل الشقق: ${response["message"]}");
      }
    } catch (e) {
      print("❌ خطأ أثناء تحميل الشقق: $e");
    }
  }

  /// حذف شقة مع التحقق من الملكية والعقد
  Future<bool> deleteApartment(int apartmentId) async {
    // تحقق أولاً أن المستخدم الحالي هو المالك
    if (ownerId.value != currentTenantId.value) {
      print("❌ لا يمكنك حذف هذه الشقة لأنك لست المالك");
      return false;
    }

    // تحقق أن العقد غير نشط
    if (["active", "waiting update", "waiting cancel"].contains(contractStatus.value)) {
      print("❌ لا يمكن حذف الشقة بوجود عقد نشط أو قيد التعديل/الإلغاء");
      return false;
    }

    // نفّذ طلب الحذف باستخدام DELETE
    final response = await crud.deleteRequest(
      linkeDeleteApartment(apartmentId),
    );

    if (response["status"] == 200 || response["status"] == 201) {
      print("✅ تم حذف الشقة بنجاح");
      return true;
    } else {
      print("❌ فشل الحذف: ${response["message"]}");
      return false;
    }
  }

  /// حذف شقة ثم تحديث القائمة
  Future<void> deleteApartmentAndRefresh(int apartmentId) async {
    bool success = await deleteApartment(apartmentId);

    if (success) {
      // رجوع خطوة للخلف
      Get.back();

      // تحديث القائمة كاملة من السيرفر
      await loadAllApartments();

      Get.snackbar("نجاح", "تم حذف الشقة وتحديث القائمة",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("خطأ", "فشل الحذف",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<void> acceptBooking(int contractId) async {
    var response = await crud.postRequest(
      AcceptBooking(contractId),
      {}, // ما في Body لأن الـ API ما يحتاجه
    );

    if (response["status"] == 200) {
      Get.snackbar(
        "نجاح",
        "تم قبول الحجز وإلغاء باقي الطلبات",
        snackPosition: SnackPosition.BOTTOM,
      );

      // تحديث الحالة محلياً
      contractStatus.value = "active";
      status.value = "rented";

      // إعادة تحميل حالة الشقة
      await loadApartmentStatus(response["contract"]["apartment_id"]);
    } else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل العملية",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> approveCancel(int contractId, int apartmentId) async {
    var response = await crud.postRequest(
      linkeApproveCancel(contractId), // رابط API قبول الإلغاء
      {}, // لا يوجد Body
    );

    if (response["status"] == 200) {
      // تحديث الحالة محلياً
      contractStatus.value = "cancelled";
      status.value = "vacant";
      tenantId.value = 0;

      Get.snackbar(
        "نجاح",
        "تم قبول طلب الإلغاء وتحرير الشقة",
        snackPosition: SnackPosition.BOTTOM,
      );

      // إعادة تحميل حالة الشقة
      await loadApartmentStatus(apartmentId);
    } else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل قبول الإلغاء",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> rejectCancel(int contractId, int apartmentId) async {
    var response = await crud.postRequest(
      linkeRejectCancel(contractId), // رابط API رفض الإلغاء
      {}, // لا يوجد Body
    );

    if (response["status"] == 200) {
      // تحديث الحالة محلياً
      contractStatus.value = "active";
      status.value = "rented";

      Get.snackbar(
        "تم الرفض",
        "تم رفض طلب الإلغاء واستمرار العقد",
        snackPosition: SnackPosition.BOTTOM,
      );

      // إعادة تحميل حالة الشقة
      await loadApartmentStatus(apartmentId);
    } else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل رفض الإلغاء",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> approveUpdate(int contractId, int apartmentId) async {
    var response = await crud.postRequest(
      linkeApproveUpdate(contractId),
      {},
    );

    if (response["status"] == 200) {
      // تحديث الحالة محلياً
      contractStatus.value = "active";
      status.value = "rented";

      Get.snackbar(
        "نجاح",
        "تم قبول طلب التعديل",
        snackPosition: SnackPosition.BOTTOM,
      );

      // إعادة تحميل حالة الشقة
      await loadApartmentStatus(apartmentId);
    } else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل قبول التعديل",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> rejectUpdate(int contractId, int apartmentId) async {
    var response = await crud.postRequest(
      linkeRejectUpdate(contractId),
      {},
    );

    if (response["status"] == 200) {
      // التعديل مرفوض → العقد يعود كما كان
      contractStatus.value = "cancelled";

      Get.snackbar(
        "تم الرفض",
        "تم رفض طلب التعديل",
        snackPosition: SnackPosition.BOTTOM,
      );

      // إعادة تحميل حالة الشقة
      await loadApartmentStatus(apartmentId);
    } else {
      Get.snackbar(
        "خطأ",
        response["message"] ?? "فشل رفض التعديل",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

}