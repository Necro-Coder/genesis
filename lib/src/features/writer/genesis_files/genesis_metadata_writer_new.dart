import 'dart:io';
import 'dart:convert';

import 'package:genesis/src/features/reader/genesis_data_reader.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/genesis_metadata_reader.dart';
import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';
import 'package:genesis/src/features/reader/models/files/genesis_metadata_model.dart';

class MetadataManager {
  final _reader = GDataReader();
  final _metadataReader = GMetadataReader();

  Future<void> manageMetadata() async {
    String jsonContent = await _metadataReader.read();
    GMetadataModel metadataModel =
        GMetadataModel(changes: [], unchanged: [], deletions: []);

    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);

    List<String> dates = jsonMap.keys.toList();
    if (dates.isNotEmpty) {
      dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
      String latestDate = dates.first;
      metadataModel = GMetadataModel.fromJson(jsonMap[latestDate]);
    }

    await _reader.readData();

    stdout.write('${GFileList().commons.first.runtimeType} files found\n');

    GeneralFile generalFiles = GeneralFile(
      files: GFileList().commons.map((e) => e).toList(),
      folders: GFolderList().commons.map((e) => e).toList(),
      properties: GPropertyList().commons.map((e) => e).toList(),
      widgets: GWidgetList().commons.map((e) => e).toList(),
      screens: GScreenList().commons.map((e) => e).toList(),
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
    stdout.write('Ultima: ${lines.last}!!\n');
    if (lines.any((item) => RegExp(r'\d').hasMatch(item))) {
      lines.add(',');
    }

    json = '"${DateTime.now().toString()}": $json';

    lines.add(json);
    lines.add('}');
    await File(filePath).writeAsString(lines.join('\n'));
  }
}
