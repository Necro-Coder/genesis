import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';

class GScreen extends GWidget {
  bool? isStateful;

  GScreen({String? name, String? path, String? template, this.isStateful})
      : super(name: name, path: path, template: template);

  factory GScreen.fromJson(Map<String, dynamic> json) {
    return GScreen(
      name: json['name'],
      path: json['path'],
      template: json['template'],
      isStateful: json['isStateful'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'template': template,
      'isStateful': isStateful,
    };
  }
}
