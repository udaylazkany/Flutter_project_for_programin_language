import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/components/crud.dart';
import '../../core/constant/linkapi.dart';
import 'Home.dart';

class Waiting extends StatefulWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  final Crud _crud = Crud();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // كل 15 دقيقة (900 ثانية)
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      print("Timer fired at ${DateTime.now()}");
      checkApproval();
    });
  }

  Future<void> checkApproval() async {
    //

     var response = await _crud.postRequest(linkelogin, { "phoneNumber": "0988704367",
     "password": "hadel98olamath",
     }); print("CheckApproval Response: $response");

    if (response != null) {
      if (response['data']['is_approved'] == 1) {
        // إذا تغيرت القيمة → روح على Home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // لازم توقف التايمر لما تترك الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("حسابك بانتظار الموافقة..."),
      ),
    );
  }
}
