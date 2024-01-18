import 'package:genesis/src/features/reader/models/flutter/genesis_screen_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_properties_model.dart';
import 'package:genesis/src/features/reader/models/project/genesis_folder_model.dart';

class GeneralFile {
  List<GFile>? files;
  List<GFolder>? folders;
  List<GProperty>? properties;
  List<GWidget>? widgets;
  List<GScreen>? screens;

  GeneralFile({
    this.files,
    this.folders,
    this.properties,
    this.widgets,
    this.screens,
  });

  factory GeneralFile.fromJson(Map<String, dynamic> json) {
    return GeneralFile(
      files: json['files'] != null
          ? (json['files'] as List)
              .map((i) => GFile.fromJson(i))
              .toList()
              .cast<GFile>()
          : null,
      folders: json['folders'] != null
          ? (json['folders'] as List)
              .map((i) => GFolder.fromJson(i))
              .toList()
              .cast<GFolder>()
          : null,
      properties: json['properties'] != null
          ? (json['properties'] as List)
              .map((i) => GProperty.fromJson(i))
              .toList()
              .cast<GProperty>()
          : null,
      widgets: json['widgets'] != null
          ? (json['widgets'] as List)
              .map((i) => GWidget.fromJson(i))
              .toList()
              .cast<GWidget>()
          : null,
      screens: json['screens'] != null
          ? (json['screens'] as List)
              .map((i) => GScreen.fromJson(i))
              .toList()
              .cast<GScreen>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'files': files?.map((e) => e.toJson()).toList(),
      'folders': folders?.map((e) => e.toJson()).toList(),
      'properties': properties?.map((e) => e.toJson()).toList(),
      'widgets': widgets?.map((e) => e.toJson()).toList(),
      'screens': screens?.map((e) => e.toJson()).toList(),
    };
  }
}
