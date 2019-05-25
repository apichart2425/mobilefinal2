import 'package:mobilefinal2/ui/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateUserLogin {
    static int id;
    static var userid;
    static var name;
    static var age;
    static var password;
    static var quote;

    static String whoCurrent(){
      return "current -> _id: ${id}, userid: ${userid}, name: ${name}, age: ${age}, password: ${password}, quote: ${quote}";
   }
}

class SP{
  static var name;

  static getCredential() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String check_user = sharedPreferences.getString('username');
        String check_password = sharedPreferences.getString('password');
        String nameSP = sharedPreferences.getString('name');
        return "current -> name: ${nameSP}";
      }
}