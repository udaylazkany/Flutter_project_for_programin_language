import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/MessageController.dart';
import 'MessagesPage.dart';

class ConversationsPage extends StatelessWidget {
  final int currentUserId;

  const ConversationsPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final messageController = Get.put(MessageController());

    // تحميل المحادثات عند فتح الصفحة (بدون باراميتر لأننا نجيب من auth)
    messageController.getUserConversations();

    return Scaffold(
      appBar: AppBar(title: const Text("قائمة المحادثات")),
      body: Obx(() {
        if (messageController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (messageController.conversations.isEmpty) {
          return const Center(child: Text("لا توجد محادثات"));
        }

        return ListView.builder(
          itemCount: messageController.conversations.length,
          itemBuilder: (context, index) {
            final conv = messageController.conversations[index];

            // تحديد الطرف الآخر (إذا المستخدم الحالي هو المالك، الطرف الآخر هو المستأجر والعكس)
            final isOwner = conv["owner_id"] == currentUserId;
            final otherUser = isOwner ? conv["tenant"] : conv["owner"];

            // آخر رسالة كـ preview
            final lastMessage = conv["messages"] != null && conv["messages"].isNotEmpty
                ? conv["messages"][0]["message"]
                : "لا توجد رسائل بعد";

            return ListTile(
              leading: CircleAvatar(
                child: Text(otherUser["firstName"][0]),
              ),
              title: Text("${otherUser["firstName"]} ${otherUser["lastName"]}"),
              subtitle: Text(lastMessage),
              onTap: () {
                Get.to(() => MessagesPage(
                  conversationId: conv["id"],
                  ownerId: conv["owner_id"],
                ));
              },
            );
          },
        );
      }),
    );
  }
}