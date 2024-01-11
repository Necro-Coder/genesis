import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/genesis_data_types/genesis_generic_classes/genesis_serializable_object.dart';
import 'package:reflectable/reflectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

class GenesisPreferences {
  static late SharedPreferences _prefs;
  static late Exceptions _exceptions;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    _exceptions = Exceptions();
  }

  static final Map<String, dynamic> userPreferences = {};

  static Future<dynamic> getValue<T>(String key) async {
    return userPreferences.containsKey(key)
        ? await _convertValue<T>(key) ?? 'none'
        : _exceptions.throwPreferencesNoneValue(key);
  }

  static Future<void> setValue<T>(String key, dynamic value) async {
    userPreferences.containsKey(key)
        ? await _convertValue<T>(key, value: value)
        : _exceptions.throwPreferencesNoneValue(key);
  }

  static Future<void> restorePreferences() async {
    userPreferences.forEach((key, value) async {
      await _convertValue(key, value: value);
    });
  }

  static Future<T> _convertValue<T>(dynamic key, {dynamic value = ''}) async {
    late dynamic returnValue;

    switch (value.runtimeType) {
      case String:
        returnValue = value != ''
            ? await _prefs.setString(key, value) as T
            : _prefs.getString(key) as T;
        break;
      case int:
        returnValue = value != ''
            ? await _prefs.setInt(key, value) as T
            : _prefs.getInt(key) as T;
        break;
      case double:
        returnValue = value != ''
            ? await _prefs.setDouble(key, value) as T
            : _prefs.getDouble(key) as T;
        break;
      case bool:
        returnValue = value != ''
            ? await _prefs.setBool(key, value) as T
            : _prefs.getBool(key) as T;
        break;
      case List:
        returnValue = value != ''
            ? await _prefs.setStringList(key, value) as T
            : _prefs.getStringList(key) as T;
        break;
      case GenesisSerializableObject:
        var instanceClass = reflector.reflectType(value) as ClassMirror;

        try {
          returnValue = value != ''
              ? await _prefs.setString(key, value.toMap().toString()) as T
              : instanceClass.newInstance(
                  'fromMap', _prefs.getStringList(key) ?? []);
        } catch (e) {
          _exceptions.throwBadPreferencesType(key);
        }
        break;
      default:
        _exceptions.throwNoPreferencesElement(value.runtimeType);
    }

    return returnValue;
  }
}
