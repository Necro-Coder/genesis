import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';

/// `GMetadataModel` is a class that represents the metadata of a general file in the system.
///
/// It is used to manage and manipulate metadata information throughout the application.
/// This class can be extended to create more specific metadata types,
/// such as text metadata, image metadata, etc.
///
/// Example:
/// ```dart
/// GMetadataModel myMetadata = GMetadataModel();
/// ```
///
/// This will create a new instance of `GMetadataModel`.
class GMetadataModel {
  /// `changes` is a `GeneralFile` object that represents the changes in the system.
  ///
  /// It is used to manage and manipulate the changed file data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myChanges = GeneralFile();
  /// GMetadataModel myMetadata = GMetadataModel(changes: myChanges);
  /// ```
  ///
  /// This will create a new `GMetadataModel` object with the given changes.
  GeneralFile? changes;

  /// `unchanged` is a `GeneralFile` object that represents the unchanged files in the system.
  ///
  /// It is used to manage and manipulate the unchanged file data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myUnchanged = GeneralFile();
  /// GMetadataModel myMetadata = GMetadataModel(unchanged: myUnchanged);
  /// ```
  ///
  /// This will create a new `GMetadataModel` object with the given unchanged files.
  GeneralFile? unchanged;

  /// `deletions` is a `GeneralFile` object that represents the deleted files in the system.
  ///
  /// It is used to manage and manipulate the deleted file data throughout the application.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myDeletions = GeneralFile();
  /// GMetadataModel myMetadata = GMetadataModel(deletions: myDeletions);
  /// ```
  ///
  /// This will create a new `GMetadataModel` object with the given deletions.
  GeneralFile? deletions;

  /// Creates a new `GMetadataModel` object.
  ///
  /// The `GMetadataModel` constructor is used to create a new `GMetadataModel` object with the given attributes.
  /// Each attribute represents a different type of change in the system.
  ///
  /// - `changes`: A `GeneralFile` object representing the changes in the system.
  /// - `unchanged`: A `GeneralFile` object representing the unchanged files in the system.
  /// - `deletions`: A `GeneralFile` object representing the deleted files in the system.
  ///
  /// Example:
  /// ```dart
  /// GeneralFile myChanges = GeneralFile();
  /// GeneralFile myUnchanged = GeneralFile();
  /// GeneralFile myDeletions = GeneralFile();
  /// GMetadataModel myMetadata = GMetadataModel(
  ///   changes: myChanges,
  ///   unchanged: myUnchanged,
  ///   deletions: myDeletions,
  /// );
  /// ```
  ///
  /// This will create a new `GMetadataModel` object with the given attributes.
  GMetadataModel({
    this.changes,
    this.unchanged,
    this.deletions,
  });

  /// Creates a new `GMetadataModel` object from a JSON map.
  ///
  /// The `fromJson` factory method is used to create a new `GMetadataModel` object from a map object,
  /// where the keys are the names of the metadata attributes (i.e., 'changes', 'unchanged', 'deletions')
  /// and the values are the corresponding attribute values in JSON format.
  ///
  /// Each attribute value is converted from JSON using the `fromJson` method of the `GeneralFile` class.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> json = {...};
  /// GMetadataModel myMetadata = GMetadataModel.fromJson(json);
  /// ```
  ///
  /// This will create a new `GMetadataModel` object from the JSON map.
  factory GMetadataModel.fromJson(Map<String, dynamic> json) {
    return GMetadataModel(
      changes: GeneralFile.fromJson(json['changes']),
      unchanged: GeneralFile.fromJson(json['unchanged']),
      deletions: GeneralFile.fromJson(json['deletions']),
    );
  }

  /// Converts the `GMetadataModel` object to a JSON map.
  ///
  /// The `toJson` method is used to convert the `GMetadataModel` object into a map object,
  /// where the keys are the names of the metadata attributes (i.e., 'changes', 'unchanged', 'deletions')
  /// and the values are the corresponding attribute values.
  ///
  /// Each attribute value is also converted to JSON using the `toJson` method of the `GeneralFile` class.
  /// If an attribute is null, a new `GeneralFile` object is created and converted to JSON.
  ///
  /// Example:
  /// ```dart
  /// GMetadataModel myMetadata = GMetadataModel();
  /// Map<String, dynamic> json = myMetadata.toJson();
  /// ```
  ///
  /// This will convert the `myMetadata` object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'changes': changes == null ? GeneralFile().toJson() : changes!.toJson(),
      'unchanged':
          unchanged == null ? GeneralFile().toJson() : unchanged!.toJson(),
      'deletions':
          deletions == null ? GeneralFile().toJson() : deletions!.toJson(),
    };
  }
}
