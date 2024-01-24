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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GFolder &&
        other.name == name &&
        other.path == path &&
        other.isGeneration == isGeneration;
  }

  @override
  int get hashCode {
    return name.hashCode ^ path.hashCode ^ isGeneration.hashCode;
  }
}
