import 'package:genesis/src/features/reader/models/common.dart';

class GFile extends Common {
  final bool? isBarrel;
  final bool? isModel;
  final String? extension;

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
}
