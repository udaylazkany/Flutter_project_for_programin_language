import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/TextFiled.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../controller/MessageController.dart';

class MessagesPage extends StatefulWidget {
  final int? conversationId; // ← صارت nullable
  final int ownerId;

  MessagesPage({
    super.key,
    this.conversationId,
    required this.ownerId,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final MessageController controller = Get.put(MessageController());
  final TextEditingController messageController = TextEditingController();
  final storage = const FlutterSecureStorage();

  int? currentConversationId;

  Future<int> _getCurrentUserId() async {
    String? id = await storage.read(key: "userId");
    return int.tryParse(id ?? "0") ?? 0;
  }

  @override
  void initState() {
    super.initState();

    currentConversationId = widget.conversationId;

    // تحميل الرسائل فقط إذا في محادثة موجودة
    if (currentConversationId != null) {
      controller.getMessages(currentConversationId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الرسائل")),
      body: Column(
        children: [
          // ------------------ عرض الرسائل ------------------
          Expanded(
            child: FutureBuilder<int>(
              future: _getCurrentUserId(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final currentUserId = snapshot.data!;

                return Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (currentConversationId == null ||
                      controller.messages.isEmpty) {
                    return const Center(child: Text("لا توجد رسائل"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final m = controller.messages[index];
                      final messageText = m["message"];
                      final senderId = m["sender_id"];

                      String senderName;
                      if (senderId == currentUserId) {
                        senderName = "أنت";
                      } else if (senderId == widget.ownerId) {
                        senderName = "المالك";
                      } else {
                        senderName = "المستأجر";
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              senderName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              messageText,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ),

          // ------------------ إدخال رسالة جديدة ------------------
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: "اكتب رسالتك هنا",
                    controller: messageController,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (messageController.text.isEmpty) return;

                    // إرسال الرسالة
                    int? newId = await controller.sendMessage(
                      conversationId: currentConversationId,
                      ownerId: widget.ownerId,
                      message: messageController.text,
                    );

                    // إذا المحادثة كانت null → الآن صارت موجودة
                    if (currentConversationId == null && newId != null) {
                      setState(() {
                        currentConversationId = newId;
                      });
                    }

                    messageController.clear();
                  },
                  child: const Text("إرسال"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
