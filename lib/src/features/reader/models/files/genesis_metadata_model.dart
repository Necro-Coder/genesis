import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';

class GMetadataModel {
  final List<GeneralFile> changes;
  final List<GeneralFile> unchanged;
  final List<GeneralFile> deletions;

  GMetadataModel({
    required this.changes,
    required this.unchanged,
    required this.deletions,
  });

  factory GMetadataModel.fromJson(Map<String, dynamic> json) {
    return GMetadataModel(
      changes: json['changes'] != null
          ? (json['changes'] as List)
              .map((i) => GeneralFile.fromJson(i))
              .toList()
              .cast<GeneralFile>()
          : [],
      unchanged: json['unchanged'] != null
          ? (json['unchanged'] as List)
              .map((i) => GeneralFile.fromJson(i))
              .toList()
              .cast<GeneralFile>()
          : [],
      deletions: json['deletions'] != null
          ? (json['deletions'] as List)
              .map((i) => GeneralFile.fromJson(i))
              .toList()
              .cast<GeneralFile>()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '${DateTime.now()}': {
        'changes': changes.map((e) => e.toJson()).toList(),
        'unchanged': unchanged.map((e) => e.toJson()).toList(),
        'deletions': deletions.map((e) => e.toJson()).toList(),
      }
    };
  }
}
