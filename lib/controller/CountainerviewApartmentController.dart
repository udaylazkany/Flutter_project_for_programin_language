import 'package:get/get.dart';
import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';

class CountainerviewApartmentController extends GetxController {
  final Crud crud = Crud();

  // حالة كل شقة
  var apartmentsStatus = <int, String>{}.obs;

  // المستأجر الحالي لكل شقة
  var apartmentsTenant = <int, int>{}.obs;

  // رقم العقد لكل شقة
  var apartmentsContract = <int, int>{}.obs;
  Future<void> loadAllApartments() async {
    try {
      var response = await crud.getRequest(linkeviewall);

      if (response["status"] == 200 || response["status"] == 201) {
        List apartments = response["data"]["Appartment"];
        List addresses = response["data"]["Apartment_Address"];

        // خزّن البيانات في الخرائط أو في قوائم حسب تصميمك
        for (var apartment in apartments) {
          int id = apartment["id"];
          apartmentsStatus[id] = apartment["statusApartments"] ?? "unknown";
          apartmentsTenant[id] = apartment["tenant_id"] ?? 0;
          apartmentsContract[id] = apartment["contract_id"] ?? 0;
        }

        // إذا بدك تخزن العناوين كمان
        // ...
      } else {
        print("❌ فشل تحميل الشقق: ${response["message"]}");
      }
    } catch (e) {
      print("❌ خطأ أثناء تحميل الشقق: $e");
    }
  }
  // تحميل حالة شقة واحدة
  Future<void> loadApartmentStatus(int apartmentId) async {
    try {
      var response = await crud.postRequest(
        linkeViewApartmentStatus,
        {"apartment_id": apartmentId},
      );

      if (response["status"] == 200 || response["status"] == 201) {
        apartmentsStatus[apartmentId] =
            response["data"]["statusApartments"] ?? "unknown";

        apartmentsTenant[apartmentId] =
            response["data"]["tenant_id"] ?? 0;

        apartmentsContract[apartmentId] =
            response["data"]["contract_id"] ?? 0;
      } else {
        apartmentsStatus[apartmentId] = "unknown";
      }
    } catch (e) {
      apartmentsStatus[apartmentId] = "unknown";
    }
  }

  // 🔹 تحميل كل الشقق دفعة واحدة
}