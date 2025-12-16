import 'package:get/get.dart';

class Mylocale implements Translations
{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    "ar":{"1":"أهلاً بكم "
    ,"2":"تسجيل الدخول",
      "3":"ادخل رقم الهاتف",
      "4":"ادخل كلمة المرور",
      "5":"تسجيل الدخول",
      "6":"لا تملك حساب!",
      "7":"إنشاء حساب  ",
      "8":"تملك حساب",
      "9":"إضافة صورة",
      "10":"إضافة بطاقة"

    },



    "en":{"1":"Welcome",
    "2":"login",
    "3":"Enter phone Number",
    "4":"Enter The password",
      "5":"sing in",
      "6":"Don't have Account!  ",
      "7":"register",
      "8":"have Account",
      "9":"add photo",
      "10":"add Card"

    }
  };

}