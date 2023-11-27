import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  
   static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }
  static String? _host = '';
  static String? get host => _prefs.getString('host') ?? _host;
  static set host(String? value) {
    _host = value;
    _prefs.setString('host', _host!);
  }
    static int? _port = 0;
  static int? get port => _prefs.getInt('port') ?? _port;
  static set port(int? value) {
    _port = value;
    _prefs.setInt('port', _port!);
  }
    static String? _user = '';
  static String? get user => _prefs.getString('user') ?? _user;
  static set user(String? value) {
    _user = value;
    _prefs.setString('user', _user!);
  }
    static String? _password = '';
  static String? get password => _prefs.getString('password') ?? _password;
  static set password(String? value) {
    _password = value;
    _prefs.setString('password', _password!);
  }
  



}