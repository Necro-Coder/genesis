import 'package:genesis/src/features/reader/models/common.dart';

class GProperty extends Common {
  String? type;
  String? defaultValue;
  bool? isPrimary;
  bool? isForeign;
  String? table;

  GProperty({
    String? name,
    String? path,
    this.type,
    this.defaultValue,
    this.isPrimary,
    this.isForeign,
    this.table,
  }) : super(name: name, path: path);

  factory GProperty.fromJson(Map<String, dynamic> json) {
    return GProperty(
      name: json['name'],
      path: json['path'],
      type: json['type'],
      defaultValue: json['defaultValue'],
      isPrimary: json['isPrimary'],
      isForeign: json['isForeign'],
      table: json['table'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'defaultValue': defaultValue,
      'isPrimary': isPrimary,
      'isForeign': isForeign,
      'table': table,
    };
  }
}
