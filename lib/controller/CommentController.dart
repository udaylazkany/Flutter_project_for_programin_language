import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';

class CommentController {
  Crud crud = Crud();

  // ================================
  // جلب التعليقات
  // ================================
  Future<List<dynamic>> getComments(int apartmentId) async {
    var response = await crud.getRequest(linkeviewComents(apartmentId));

    if (response is Map && response["status"] == false) {
      return []; // خطأ أو لا يوجد بيانات
    }

    return response;
  }

  // ================================
  // إرسال تعليق
  // ================================
  Future<bool> sendComment({
    required int apartmentId,
    required int tenantId,
    required String comment,
  }) async {
    var response = await crud.postRequest(
      linkeAddComment,
      {
        "apartment_id": apartmentId.toString(),
        "tenant_id": tenantId.toString(),
        "Comment": comment,
      },
    );

    return response["status"] != false;
  }

  // ================================
  // التحقق إذا المستخدم يحق له التعليق
  // ================================
  Future<bool> canUserComment(int apartmentId, int tenantId) async {
    var response = await crud.getRequest(
      linkeCanComment(apartmentId, tenantId),
    );

    // تأكد أن القيمة bool حقيقية
    if (response is Map && response["can_comment"] != null) {
      return response["can_comment"] == true;
    }

    return false;
  }
}