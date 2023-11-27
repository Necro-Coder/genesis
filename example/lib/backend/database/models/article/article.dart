import 'dart:convert';

import 'package:sqflite_simple_dao_backend/database/database/Reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

/* Important to use the sqflite_simple_dao_backend to import the @reflector */
@reflector
class Article {
  /* Variables we have in the model */
  int? code;
  double? price;
  String? name;
  String? description;

  /* Empty constructor */
  Article();

  /* Named constructor with all the fields and named '.all()' */
  Article.all({
    this.code,
    this.price,
    this.name,
    this.description,
  });

  /* A map that contains the name of the fields and the database types. */
  static final Map<String, String> _fields = {
    "code": Constants.integer,
    "price": Constants.decimal["9,2"]!,
    "name": Constants.varchar["20"]!,
    "description": Constants.varchar["255"]!,
  };

  /* This factory to create objects from json */
  factory Article.fromRawJson(String str) => Article.fromJson(json.decode(str));

  /* The fromJson */
  factory Article.fromJson(Map<String, dynamic> json) => Article.all(
        code: json["code"],
        price: json["price"],
        name: json["name"],
        description: json["description"],
      );

  /* The toJson */
  Map<String, dynamic> toJson() => {
        "code": code,
        "price": price,
        "name": name,
        "description": description,
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

    return other is Article &&
        other.code == code &&
        other.price == price &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        price.hashCode ^
        name.hashCode ^
        description.hashCode;
  }
}
