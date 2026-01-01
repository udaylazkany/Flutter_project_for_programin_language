import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/TextFiled.dart';
import '../../controller/CommentController.dart';
import '../../core/constant/linkapi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class CommentsPage extends StatelessWidget {
  final int apartmentId;
  final CommentController controller = CommentController();
  final TextEditingController commentController = TextEditingController();
  final storage = const FlutterSecureStorage();

  CommentsPage({super.key, required this.apartmentId});

  // نجهز الـ Future مرة واحدة فقط
  Future<Map<String, dynamic>> loadData() async {
    String? id = await storage.read(key: "userId");
    int tenantId = int.tryParse(id ?? "0") ?? 0;

    final comments = await controller.getComments(apartmentId);
    final canComment = await controller.canUserComment(apartmentId, tenantId);

    return {
      "tenantId": tenantId,
      "comments": comments,
      "canComment": canComment,
    };
  }

  @override
  Widget build(BuildContext context) {
    final futureData = loadData(); // مهم: استدعاء مرة واحدة فقط

    return Scaffold(
      appBar: AppBar(title:  Text("38".tr)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tenantId = snapshot.data!["tenantId"];
          final comments = snapshot.data!["comments"] as List;
          final canComment = snapshot.data!["canComment"] as bool;

          return Column(
            children: [
              // ------------------ عرض التعليقات ------------------
              Expanded(
                child: comments.isEmpty
                    ?  Center(child: Text("62".tr))
                    : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    final commentText = c["Comment"];
                    final firstName =
                        c["tenant"]?["firstName"] ?? " ";
                    final lastName = c["tenant"]?["lastName"] ?? "";
                    final photoPath = c["tenant"]?["personal_photo"];
                    final imageUrl =
                        "$linkeserverName/storage/$photoPath";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(imageUrl),
                            onBackgroundImageError: (_, __) {},
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$firstName $lastName",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  commentText,
                                  style:
                                  const TextStyle(fontSize: 16,color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ------------------ إدخال تعليق جديد ------------------
              if (canComment)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: "63".tr,
                          controller: commentController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (commentController.text.isEmpty) return;

                          final success = await controller.sendComment(
                            apartmentId: apartmentId,
                            tenantId: tenantId,
                            comment: commentController.text,
                          );

                          if (success) {
                            commentController.clear();

                            // إعادة بناء الصفحة مرة واحدة فقط
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CommentsPage(apartmentId: apartmentId),
                              ),
                            );
                          }
                        },
                        child:  Text("64".tr),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}