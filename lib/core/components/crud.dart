import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class Crud {
  final storage = const FlutterSecureStorage();

  // ================================
  // Helper: تجهيز الهيدر مع التوكين
  // ================================
  Future<Map<String, String>> _headers({bool withToken = false}) async {
    String? token = await storage.read(key: "token");

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (withToken && token != null) "Authorization": "Bearer $token",
    };
  }

  // ================================
  // 1) POST بدون توكين (تسجيل دخول)
  // ================================
  Future<dynamic> postRequestNoToken(String url, Map data) async {
    try {
      var response = await http
          .post(
        Uri.parse(url),
        headers: await _headers(withToken: false),
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      print("POST NO TOKEN ERROR: $e");
      return {"status": false, "message": "Connection error"};
    }
  }

  // ================================
  // 2) POST مع توكين
  // ================================
  Future<dynamic> postRequest(String url, Map data) async {
    try {
      var response = await http
          .post(
        Uri.parse(url),
        headers: await _headers(withToken: true),
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      print("POST ERROR: $e");
      return {"status": false, "message": "Connection error"};
    }
  }

  // ================================
  // 3) GET مع توكين
  // ================================
  Future<dynamic> getRequest(String url) async {
    try {
      var response = await http
          .get(
        Uri.parse(url),
        headers: await _headers(withToken: true),
      )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      print("GET ERROR: $e");
      return {"status": false, "message": "Connection error"};
    }
  }

  // ================================
  // معالجة الرد من السيرفر
  // ================================
  dynamic _handleResponse(http.Response response) {
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    // أخطاء Laravel Sanctum الشائعة
    if (response.statusCode == 401) {
      return {"status": false, "message": "Unauthorized (Token invalid)"};
    }

    if (response.statusCode == 422) {
      return {
        "status": false,
        "message": "Validation error",
        "errors": jsonDecode(response.body)
      };
    }

    return {
      "status": false,
      "message": "Server error",
      "code": response.statusCode
    };
  }
  Future<dynamic> postRequestWithFile(String url, Map<String, String> data, String filePath) async {
    try {
      String? token = await storage.read(key: "token");

      var request = http.MultipartRequest("POST", Uri.parse(url));

      // إضافة الهيدر
      request.headers.addAll({
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      });

      // إضافة البيانات العادية
      data.forEach((key, value) {
        request.fields[key] = value;
      });

      // إضافة الصورة
      if (filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath("image", filePath),
        );
      }

      // إرسال الطلب
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);

    } catch (e) {
      print("POST FILE ERROR: $e");
      return {"status": false, "message": "Connection error"};
    }
  }
}