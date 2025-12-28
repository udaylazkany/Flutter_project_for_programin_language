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
      "10":"إضافة بطاقة",
      "11":"حسابك بانتظار الموافقة...",
      "12":"خطأ في تسجيل الدخول: رقم الهاتف أو كلمة السر غير صحيحة",
      "13":"الصفحة الرئيسية",
      "14":"لا توجد بيانات حاليا",
      "15":"تفاصيل الشقة",
      "16":"إضافة شقة ",
      "17":"Change To English",
      "18":"تسجيل الخروج",
      "19":"تبديل المظهر"

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
      "10":"add Card",
      "11":"Your account is waiting for approval....",
      "12":"Login failed: Incorrect phone number or password",
      "13":"Home Page",
      "14":"No data available right now",
      "15":"Apartment Details",
      "16":"Add ApartmentPage",
      "17":"تغيير للغة العربية ",
      "18":"logout",
      "19":"Changed Theme"

    }
  };

}