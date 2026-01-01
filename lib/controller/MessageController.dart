import 'package:get/get.dart';
import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessageController extends GetxController {
  final Crud crud = Crud();
  final storage = const FlutterSecureStorage();

  var messages = <Map<String, dynamic>>[].obs;
  var conversations = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // ================================
  // جلب الرسائل لمحادثة معينة
  // ================================
  Future<void> getMessages(int conversationId) async {
    isLoading.value = true;

    var response = await crud.getRequest(linkeViewMessages(conversationId));

    if (response is Map<String, dynamic>) {
      final msgs = response["messages"];
      if (msgs is List) {
        messages.value = List<Map<String, dynamic>>.from(msgs);
      } else {
        messages.value = [];
      }
    } else {
      messages.value = [];
    }

    isLoading.value = false;
  }

  // ================================
  // إرسال رسالة (يدعم وجود أو عدم وجود conversationId)
  // ================================
  Future<int?> sendMessage({
    required int ownerId,
    required String message,
    int? conversationId,
  }) async {
    // المستخدم الحالي (المستأجر أو صاحب الشقة)
    String? id = await storage.read(key: "userId");
    int currentUserId = int.tryParse(id ?? "0") ?? 0;

    // الرابط الصحيح
    String url = linkeAddMessage(conversationId);

    // إرسال البيانات
    var response = await crud.postRequest( url, { "message": message, }, );

    // إذا المحادثة جديدة
    if (response != null && response["conversation_id"] != null) {
      int newConversationId = response["conversation_id"];
      await getMessages(newConversationId);
      return newConversationId;
    }

    // إذا المحادثة موجودة
    if (conversationId != null) {
      await getMessages(conversationId);
      return conversationId;
    }

    return null;
  }

  // ================================
  // جلب قائمة المحادثات الخاصة بالمستخدم الحالي
  // ================================
  Future<void> getUserConversations() async {
    isLoading.value = true;

    String? id = await storage.read(key: "userId");
    int clientId = int.tryParse(id ?? "0") ?? 0;

    var response = await crud.getRequest(linkUserConversations(clientId));

    if (response is List) {
      conversations.value = List<Map<String, dynamic>>.from(response);
    } else {
      conversations.value = [];
    }

    isLoading.value = false;
  }
}
