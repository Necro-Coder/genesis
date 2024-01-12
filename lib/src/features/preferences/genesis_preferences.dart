import 'dart:convert';

import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/genesis_data_types/genesis_generic_classes/genesis_serializable_object.dart';
import 'package:reflectable/reflectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

class GenesisPreferences {
  /// `_prefs` is a late-initialized static instance of `SharedPreferences`.
  /// `SharedPreferences` is a library that wraps platform-specific persistent storage (NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.).
  /// It is used to persistently store simple data like strings, booleans, integers, and doubles.
  static late SharedPreferences _prefs;

  /// `init` is a static method that initializes the `GenesisPreferences` class.
  /// It asynchronously gets an instance of `SharedPreferences` and assigns it to `_prefs`.
  /// It also creates a new instance of `Exceptions` and assigns it to `_exceptions`.
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// `userPreferences` is a static final map that stores user preferences.
  /// The keys are strings that represent the names of the preferences.
  /// The values are dynamic and can be of any type.
  static final Map<String, dynamic> userPreferences = {};

  /// `getValue` is a static method that retrieves the value of a user preference.
  ///
  /// It takes a generic type parameter `T` and a string `key` as arguments.
  /// The `key` is the name of the user preference to retrieve.
  ///
  /// The method first checks if `userPreferences` contains the `key`.
  /// If it does, it calls the `_convertValue` method with the `key` and the type `T`.
  /// The `_convertValue` method retrieves the value from `SharedPreferences` and converts it to the type `T`.
  /// If the value is `null`, it returns the string 'none'.
  ///
  /// If `userPreferences` does not contain the `key`, it throws an exception using the `throwPreferencesNoneValue` method of the `Exceptions` class.
  ///
  /// The method is asynchronous and returns a `Future` that completes with the value of the user preference or throws an exception.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// void main() async {
  ///   // Initialize GenesisPreferences
  ///   await GenesisPreferences.init();
  ///
  ///   // Get a user preference
  ///   var username = await GenesisPreferences.getValue<String>('username');
  ///   print(username);  // Outputs: JohnDoe
  /// }
  /// ```
  static Future<dynamic> getValue<T>(String key) async {
    return userPreferences.containsKey(key)
        ? await _convertValue<T>(key) ?? 'none'
        : Exceptions().throwPreferencesNoneValue(key);
  }

  /// `setValue` is a static method that sets the value of a user preference.
  ///
  /// It takes a generic type parameter `T`, a string `key`, and a dynamic `value` as arguments.
  /// The `key` is the name of the user preference to set, and `value` is the new value.
  ///
  /// The method first checks if `userPreferences` contains the `key`.
  /// If it does, it calls the `_convertValue` method with the `key`, the type `T`, and the `value`.
  /// The `_convertValue` method stores the `value` in `SharedPreferences` and converts it to the type `T`.
  ///
  /// If `userPreferences` does not contain the `key`, it throws an exception using the `throwPreferencesNoneValue` method of the `Exceptions` class.
  ///
  /// The method is asynchronous and returns a `Future` that completes when the value has been set or throws an exception.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// void main() async {
  ///   // Initialize GenesisPreferences
  ///   await GenesisPreferences.init();
  ///
  ///   // Set a user preference
  ///   await GenesisPreferences.setValue<String>('username', 'JohnDoe');
  ///
  ///   // Get a user preference
  ///   var username = await GenesisPreferences.getValue<String>('username');
  ///   print(username);  // Outputs: JohnDoe
  /// }
  /// ```
  static Future<void> setValue<T>(String key, dynamic value) async {
    userPreferences.containsKey(key)
        ? await _convertValue<T>(key, value: value)
        : Exceptions().throwPreferencesNoneValue(key);
  }

  /// `restorePreferences` is a static method that restores the default values of user preferences into `SharedPreferences`.
  ///
  /// This method iterates over the entries of the `userPreferences` map. For each key-value pair, it calls the `_convertValue` method with the key and the value.
  /// The `_convertValue` method takes the value from `userPreferences`, converts it to the corresponding type, and stores it in `SharedPreferences`.
  ///
  /// The method is asynchronous and returns a `Future` that completes when all user preferences have been restored to their default values in `SharedPreferences`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// void main() async {
  ///   // Initialize GenesisPreferences
  ///   await GenesisPreferences.init();
  ///
  ///   // Set a user preference
  ///   await GenesisPreferences.setValue<String>('username', 'JohnDoe');
  ///
  ///   // Restore user preferences to their default values
  ///   await GenesisPreferences.restorePreferences();
  ///
  ///   // Get a user preference
  ///   var username = await GenesisPreferences.getValue<String>('username');
  ///   print(username);  // Outputs: default value for 'username'
  /// }
  /// ```
  static Future<void> restorePreferences() async {
    for (var x in userPreferences.entries) {
      await _convertValue(x.key, value: x.value);
    }
  }

  /// `_convertValue` is a private static method that converts and stores a value in `SharedPreferences`.
  ///
  /// This method takes a generic type parameter `T`, a dynamic `key`, and an optional dynamic `value` with a default value of an empty string.
  /// The `key` is the name of the user preference to set, and `value` is the new value.
  ///
  /// The method uses a switch statement to handle different types of values: `String`, `int`, `double`, `bool`, `List`, and `GenesisSerializableObject`.
  /// For each type, it checks if the `value` is not an empty string. If it's not, it stores the `value` in `SharedPreferences` using the appropriate method (`setString`, `setInt`, etc.).
  /// If the `value` is an empty string, it retrieves the value from `SharedPreferences` using the appropriate method (`getString`, `getInt`, etc.).
  ///
  /// For `GenesisSerializableObject`, it uses reflection to get the instance of the class and then either stores the serialized map of the object in `SharedPreferences` or creates a new instance from the stored map.
  /// If the `value` is a list of `GenesisSerializableObject`, it stores each serialized object in the list in `SharedPreferences` and returns a list of new instances created from the stored maps.
  ///
  /// If the `value` is not one of the handled types, it throws an exception using the `throwNoPreferencesElement` method of the `Exceptions` class.
  ///
  /// The method is asynchronous and returns a `Future` of type `T` that completes with the stored or retrieved value.
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
              ? await _prefs.setString(key, jsonEncode(value.toMap())) as T
              : [
                  for (var x
                      in _getGenesisValues((_prefs.getStringList(key)) ?? []))
                    instanceClass.newInstance('fromMap', x)
                ];
        } catch (e) {
          Exceptions().throwBadPreferencesType(key);
        }
        break;
      default:
        Exceptions().throwNoPreferencesElement(value.runtimeType);
    }

    return returnValue;
  }

  /// `_getGenesisValues` is a private static method that decodes a list of JSON strings.
  ///
  /// This method takes a list of strings `values` as input, where each string is a JSON-encoded value.
  ///
  /// The method initializes an empty list `decodedValues` to store the decoded values.
  ///
  /// It then iterates over the `values` list. For each `value`, it decodes the JSON string using `jsonDecode` and adds the resulting value to the `decodedValues` list.
  ///
  /// After all values have been decoded, the method returns the `decodedValues` list.
  ///
  /// The return type is `dynamic` because JSON values can be of any type: `null`, `bool`, `double`, `String`, `List<dynamic>`, or `Map<String, dynamic>`.
  static dynamic _getGenesisValues(List<String> values) {
    var decodedValues = [];

    for (var value in values) {
      decodedValues.add(jsonDecode(value));
    }

    return decodedValues;
  }
}
