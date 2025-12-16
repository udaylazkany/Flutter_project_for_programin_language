import 'package:http/http.dart' as http;
import 'dart:convert';
class Crud
{
  getRequest(String url)  async{

    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode==200)
        {
          var responsebody=jsonDecode(response.body);
          return responsebody;

        }else
          {
            print("error ${response.statusCode}");
          }

    }
    catch(e){
      print("error catch $e");

    }
  }
//////////////////
  postRequest(String url,Map data)  async{

    try{
      print("object");

      var response = await http.post(Uri.parse(url),headers: {"Content-Type": "application/json"},body:jsonEncode(data));
      if(response.statusCode==201||response.statusCode==200)
      {
        var responsebody=jsonDecode(response.body);
        return responsebody;

      }else
      {
        print("error ${response.statusCode}");
      }

    }
    catch(e){
      print("error catch $e");

    }
  }

}