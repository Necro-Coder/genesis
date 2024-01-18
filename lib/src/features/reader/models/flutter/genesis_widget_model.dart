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
}
