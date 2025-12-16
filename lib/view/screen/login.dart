import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/components/crud.dart';
import 'package:flutter_application_2/view/screen/register.dart';
import 'package:flutter_application_2/view/widget/button.dart';
import 'package:get/get.dart';

import '../../core/constant/linkapi.dart';
import '../widget/TextFiled.dart';
import 'Home.dart';
import 'wait.dart';

class Login extends StatelessWidget {
  final Crud _crud = Crud();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    var response = await _crud.postRequest(linkelogin, {
      "phoneNumber": phoneNumber.text,
      "password": password.text,

    });




    if (response != null) {
      print("Response: $response");

      if (response['status'] == 201) {
        if(response['data']['is_approved']==1)
          {Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false,
          );

          }else
            {Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Waiting()),
                    (Route<dynamic> route) => false);}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No response from server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset('assets/Images/logo.png'),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "2".tr,
                          style: const TextStyle(
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        CustomTextField(
                          key: const ValueKey("phoneNumber"),
                          hintText: "3".tr,
                          obscureText: false,
                          controller: phoneNumber,
                        ),
                        CustomTextField(
                          key: const ValueKey("password"),
                          hintText: "4".tr,
                          obscureText: true,
                          controller: password,
                        ),
                        button(
                          hinttext: "2".tr,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await signUp(context);
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("6".tr),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  register(),
                                  ),
                                );
                              },
                              child: Text("7".tr),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}