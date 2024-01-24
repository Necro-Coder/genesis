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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GProperty &&
        other.name == name &&
        other.path == path &&
        other.type == type &&
        other.defaultValue == defaultValue &&
        other.isPrimary == isPrimary &&
        other.isForeign == isForeign &&
        other.table == table;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        path.hashCode ^
        type.hashCode ^
        defaultValue.hashCode ^
        isPrimary.hashCode ^
        isForeign.hashCode ^
        table.hashCode;
  }
}
