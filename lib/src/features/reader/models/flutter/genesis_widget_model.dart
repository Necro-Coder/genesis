import 'package:genesis/src/features/reader/models/common.dart';

class GWidget extends Common {
  String? template;

  GWidget({String? name, String? path, this.template})
      : super(name: name, path: path);

  factory GWidget.fromJson(Map<String, dynamic> json) {
    return GWidget(
      name: json['name'],
      path: json['path'],
      template: json['template'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'template': template,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GWidget &&
        other.name == name &&
        other.path == path &&
        other.template == template;
  }

  @override
  int get hashCode {
    return name.hashCode ^ path.hashCode ^ template.hashCode;
  }
}
