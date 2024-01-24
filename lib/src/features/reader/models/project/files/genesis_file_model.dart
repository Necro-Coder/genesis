import 'package:genesis/src/features/reader/models/common.dart';

class GFile extends Common {
  bool? isBarrel;
  bool? isModel;
  String? extension;

  GFile(
      {String? name, String? path, this.isBarrel, this.isModel, this.extension})
      : super(name: name, path: path);

  factory GFile.fromJson(Map<String, dynamic> json) {
    return GFile(
      name: json['name'],
      path: json['path'],
      isBarrel: json['isBarrel'],
      isModel: json['isModel'],
      extension: json['extension'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'isBarrel': isBarrel,
      'isModel': isModel,
      'extension': extension,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GFile &&
        other.name == name &&
        other.path == path &&
        other.isBarrel == isBarrel &&
        other.isModel == isModel &&
        other.extension == extension;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        path.hashCode ^
        isBarrel.hashCode ^
        isModel.hashCode ^
        extension.hashCode;
  }
}
