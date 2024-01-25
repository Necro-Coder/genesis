import 'package:genesis/src/features/reader/models/flutter/genesis_screen_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_properties_model.dart';
import 'package:genesis/src/features/reader/models/project/genesis_folder_model.dart';

/// `GeneralFile` is a class that represents a general file in the system.
///
/// It is used to manage and manipulate file data throughout the application.
/// This class can be extended to create more specific file types,
/// such as text files, image files, etc.
///
/// Example:
/// ```dart
/// GeneralFile myFile = GeneralFile();
/// ```
///
/// This will create a new instance of `GeneralFile`.
class GeneralFile {
  /// `files` is a list of `GFile` objects.
  ///
  /// Each `GFile` object represents a file in the system.
  /// This list is used to manage and manipulate file data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// List<GFile> myFiles = [...];
  /// GeneralFile myFile = GeneralFile(files: myFiles);
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given list of files.
  List<GFile>? files;

  /// `folders` is a list of `GFolder` objects.
  ///
  /// Each `GFolder` object represents a folder in the system.
  /// This list is used to manage and manipulate folder data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// List<GFolder> myFolders = [...];
  /// GeneralFile myFile = GeneralFile(folders: myFolders);
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given list of folders.
  List<GFolder>? folders;

  /// `properties` is a list of `GProperty` objects.
  ///
  /// Each `GProperty` object represents a property in the system.
  /// This list is used to manage and manipulate property data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// List<GProperty> myProperties = [...];
  /// GeneralFile myFile = GeneralFile(properties: myProperties);
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given list of properties.
  List<GProperty>? properties;

  /// `widgets` is a list of `GWidget` objects.
  ///
  /// Each `GWidget` object represents a widget in the system.
  /// This list is used to manage and manipulate widget data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// List<GWidget> myWidgets = [...];
  /// GeneralFile myFile = GeneralFile(widgets: myWidgets);
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given list of widgets.
  List<GWidget>? widgets;

  /// `screens` is a list of `GScreen` objects.
  ///
  /// Each `GScreen` object represents a screen in the system.
  /// This list is used to manage and manipulate screen data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// List<GScreen> myScreens = [...];
  /// GeneralFile myFile = GeneralFile(screens: myScreens);
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given list of screens.
  List<GScreen>? screens;

  /// Creates a new `GeneralFile` object.
  ///
  /// The `GeneralFile` constructor is used to create a new `GeneralFile` object with the given attributes.
  /// Each attribute represents a different type of file or directory in the system.
  ///
  /// - `files`: A list of `GFile` objects representing the files in the system.
  /// - `folders`: A list of `GFolder` objects representing the folders in the system.
  /// - `properties`: A list of `GProperty` objects representing the properties in the system.
  /// - `widgets`: A list of `GWidget` objects representing the widgets in the system.
  /// - `screens`: A list of `GScreen` objects representing the screens in the system.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myFile = GeneralFile(
  ///   files: [...],
  ///   folders: [...],
  ///   properties: [...],
  ///   widgets: [...],
  ///   screens: [...],
  /// );
  /// ```
  ///
  /// This will create a new `GeneralFile` object with the given attributes.
  GeneralFile({
    this.files,
    this.folders,
    this.properties,
    this.widgets,
    this.screens,
  });

  /// Creates a new `GeneralFile` object from a JSON map.
  ///
  /// The `fromJson` factory method is used to create a new `GeneralFile` object from a map object,
  /// where the keys are the names of the file attributes (i.e., 'files', 'folders', 'properties', 'widgets', 'screens')
  /// and the values are the corresponding attribute values in JSON format.
  ///
  /// Each attribute value is converted from JSON using the `fromJson` method of the corresponding class.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> json = {...};
  /// GeneralFile myFile = GeneralFile.fromJson(json);
  /// ```
  ///
  /// This will create a new `GeneralFile` object from the JSON map.
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

  /// Converts the `GeneralFile` object to a JSON map.
  ///
  /// The `toJson` method is used to convert the `GeneralFile` object into a map object,
  /// where the keys are the names of the file attributes (i.e., 'files', 'folders', 'properties', 'widgets', 'screens')
  /// and the values are the corresponding attribute values.
  ///
  /// Each attribute value is also converted to JSON using the `toJson` method of the corresponding class.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myFile = GeneralFile();
  /// Map<String, dynamic> json = myFile.toJson();
  /// ```
  ///
  /// This will convert the `myFile` object to a JSON map.
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
