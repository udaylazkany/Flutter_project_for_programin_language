import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final String hinttext;
  final VoidCallback  onPressed;
  const button({super.key,
  required this.hinttext,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.only(top: 10,left: 40,right: 40,bottom: 20),child:
    Container(height: 40,width: double.infinity,decoration:
    BoxDecoration(borderRadius:
    BorderRadius.circular(25)),child:ElevatedButton(onPressed: onPressed, child:
    Center(child: Text(textAlign:TextAlign.center,style: TextStyle(),hinttext),))),);

  }
}
