import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/screen/login.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../core/components/crud.dart';
import '../widget/TextFiled.dart';
import '../widget/button.dart';
class register extends StatelessWidget {
  GlobalKey<FormState> formstate=GlobalKey();
  Crud _crud=Crud();
  TextEditingController phoneNumber=TextEditingController();

  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(

        body: Container(color: Colors.grey,child: Center(child:
        Column(children: [Image.asset('assets/Images/logo.png'),
          Padding(padding: EdgeInsetsGeometry.all(20),child: Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(25)),child: Column(children: [Text("7".tr,style: TextStyle(fontSize: 40,   fontStyle: FontStyle.italic,),)
            ,
            CustomTextField(key:  ValueKey("phoneNumber"),hintText: "3".tr,obscureText: false, controller: phoneNumber,)
            ,
            CustomTextField(key:  ValueKey("password"),hintText: "4".tr,obscureText: true, controller: password, )


              , SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            
            ElevatedButton.icon(onPressed: (){}, label: Text("9".tr),icon: Icon(Icons.add_a_photo),),
            SizedBox(width: 10,),
              ElevatedButton.icon(onPressed: (){}, label: Text("10".tr),icon: Icon(Icons.credit_card),),
            ],),
              button(hinttext: "7".tr, onPressed: (){

                print("clickprintly");
              })
              ,


            Row(mainAxisAlignment: MainAxisAlignment.center
              ,children: [Text("8".tr),TextButton(onPressed: (){   Navigator.pop(
               context
              );
              },child: Text("2".tr),)],

            )
            

          ],
          ),
          )
            ,)
        ],)
        )
          ,)
    );
  }
}
