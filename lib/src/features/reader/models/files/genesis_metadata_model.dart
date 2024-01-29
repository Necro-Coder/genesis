import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';

class GMetadataModel {
  GeneralFile? changes;

  GeneralFile? unchanged;

  GeneralFile? deletions;

  GMetadataModel({
    this.changes,
    this.unchanged,
    this.deletions,
  });

  factory GMetadataModel.fromJson(Map<String, dynamic> json) {
    return GMetadataModel(
      changes: GeneralFile.fromJson(json['changes']),
      unchanged: GeneralFile.fromJson(json['unchanged']),
      deletions: GeneralFile.fromJson(json['deletions']),
    );
  }

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
