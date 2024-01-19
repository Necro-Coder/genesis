import 'dart:io';
import 'dart:convert';

import 'package:genesis/src/features/reader/genesis_data_reader.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/genesis_metadata_reader.dart';
import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';
import 'package:genesis/src/features/reader/models/files/genesis_metadata_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_screen_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_properties_model.dart';
import 'package:genesis/src/features/reader/models/project/genesis_folder_model.dart';

class MetadataManager {
  final _reader = GDataReader();
  final _metadataReader = GMetadataReader();

  Future<void> manageMetadata() async {
    String jsonContent = await _metadataReader.read();

    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);

    List<String> dates = jsonMap.keys.toList();
    dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    String latestDate = dates.first;

    GMetadataModel metadataModel = GMetadataModel.fromJson(jsonMap[latestDate]);

    await _reader.readData();

    GeneralFile generalFiles = GeneralFile(
      files: GFileList().commons as List<GFile>,
      folders: GFolderList().commons as List<GFolder>,
      properties: GPropertyList().commons as List<GProperty>,
      widgets: GWidgetList().commons as List<GWidget>,
      screens: GScreenList().commons as List<GScreen>,
    );

    List<GeneralFile> changes =
        _compareLists(generalFiles, metadataModel.changes);
    List<GeneralFile> unchanged =
        _compareLists(generalFiles, metadataModel.unchanged);
    List<GeneralFile> deletions =
        _compareLists(generalFiles, metadataModel.deletions);

    GMetadataModel newMetadataModel = GMetadataModel(
      changes: changes,
      unchanged: unchanged,
      deletions: deletions,
    );
    await _writeMetadata(newMetadataModel);
  }

  List<GeneralFile> _compareLists(
      GeneralFile generalFiles, List<GeneralFile> list) {
    List<GeneralFile> result = [];

    for (GeneralFile file in list) {
      if (file.files == generalFiles.files &&
          file.folders == generalFiles.folders &&
          file.properties == generalFiles.properties &&
          file.widgets == generalFiles.widgets &&
          file.screens == generalFiles.screens) {
        result.add(file);
      }
    }

    return result;
  }

  Future<void> _writeMetadata(GMetadataModel metadataModel) async {
    String filePath = 'lib/genesis/genesis.metadata.json';
    File genesisMetadata = File(filePath);
    if (!genesisMetadata.existsSync()) {
      await genesisMetadata.create();
      await genesisMetadata.writeAsString('{\n\n}');
    }
    List<String> lines = await genesisMetadata.readAsLines();

    lines.removeLast();

    String json = jsonEncode(metadataModel.toJson());

    lines.add(json);
    lines.add('}');

    await File(filePath).writeAsString(lines.join('\n'));
  }
}
