import 'package:genesis/src/features/reader/models/common.dart';

class GFolder extends Common {
  bool? isGeneration;

  GFolder({String? name, String? path, this.isGeneration})
      : super(name: name, path: path);

  factory GFolder.fromJson(Map<String, dynamic> json) {
    return GFolder(
      name: json['name'],
      path: json['path'],
      isGeneration: json['isGeneration'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'isGeneration': isGeneration,
    };
  }
}
