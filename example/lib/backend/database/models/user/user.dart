import 'dart:convert';

import 'package:sqflite_simple_dao_backend/database/database/Reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

/* Important to use the sqflite_simple_dao_backend to import the @reflector */
@reflector
class User{
  /* Variables we have in the model */
    int? code;
  String? name;
  DateTime? born;

  /* Empty constructor */
  User();

  /* Named constructor with all the fields and named '.all()' */
  User.all({this.code,this.name,this.born,});

  /* A map that contains the name of the fields and the database types. */
  static final Map<String, String> _fields = {
  
"code" : Constants.integer,

"name" : Constants.varchar["20"]!,

"born" : Constants.datetime,
  };

  /* This factory to create objects from json */
  factory User.fromRawJson(String str) =>
      User.fromJson(json.decode(str));

  /* The fromJson */
  factory User.fromJson(Map<String, dynamic> json) => User.all(
  	code : json["code"],
	name : json["name"],
	born : json["born"],
  );

  /* The toJson */
  Map<String, dynamic> toJson() => {
  	"code" : code,
	"name" : name,
	"born" : born,
  };

  /* An iterable object with all the keys in the fields map. */
  static final Iterable<String> _names = _fields.keys;

  /* A list with the primary key values */
  static final List<String> _primary = [];
  
  /* A exception list in order to remove some elements from the iteration */
  static final List<String> _exception = [];

  /* A list with the complete line (string) of a foreing key. Example behind.*/
  static final List<String> _foreign = [];
  /* Example: 'FOREIGN KEY (model_id) REFERENCES model (id)' */

  /* Getters and Setters*/
  static List<String> get foreign => _foreign;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get primary => _primary;

  static List<String> get exception => _exception;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.code == code &&
other.name == name &&
other.born == born;
  }

  @override
  int get hashCode {
    return code.hashCode ^
name.hashCode ^
born.hashCode;
  }
}
