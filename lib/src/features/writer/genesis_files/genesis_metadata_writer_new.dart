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
  bool _firstWrite = false;

  Future<void> manageMetadata() async {
    String jsonContent = await _metadataReader.read();
    GMetadataModel metadataModel = GMetadataModel(
        changes: GeneralFile(),
        unchanged: GeneralFile(),
        deletions: GeneralFile());

    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);

    List<String> dates = jsonMap.keys.toList();
    if (dates.isNotEmpty) {
      dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
      String latestDate = dates.first;
      metadataModel = GMetadataModel.fromJson(jsonMap[latestDate]);
    } else {
      _firstWrite = true;
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

    GMetadataModel newMetadataModel =
        await _compareLists(generalFiles, metadataModel.changes);
    if (_firstWrite) {
      newMetadataModel.changes = generalFiles;
      newMetadataModel.deletions = GeneralFile();
      newMetadataModel.unchanged = GeneralFile();
    }
    await _writeMetadata(newMetadataModel);
  }

  Future<GMetadataModel> _compareLists(
      GeneralFile generalFiles, GeneralFile item) async {
    GMetadataModel newMetadataModel = GMetadataModel(
      changes: GeneralFile(
        files: [],
        folders: [],
        properties: [],
        widgets: [],
        screens: [],
      ),
      unchanged: GeneralFile(
        files: [],
        folders: [],
        properties: [],
        widgets: [],
        screens: [],
      ),
      deletions: GeneralFile(
        files: [],
        folders: [],
        properties: [],
        widgets: [],
        screens: [],
      ),
    );

    if (item.files == null) {
      return newMetadataModel;
    }
    stdout.writeln(
        '${item.files}, ${item.folders}, ${item.properties}, ${item.widgets}, ${item.screens}');
    for (var file in generalFiles.files!) {
      if (!item.files!.contains(file)) {
        newMetadataModel.changes.files!.add(file);
      } else {
        newMetadataModel.unchanged.files!.add(file);
      }
    }

    for (var folder in generalFiles.folders!) {
      if (!item.folders!.contains(folder)) {
        newMetadataModel.changes.folders!.add(folder);
      } else {
        newMetadataModel.unchanged.folders!.add(folder);
      }
    }

    for (var property in generalFiles.properties!) {
      if (!item.properties!.contains(property)) {
        newMetadataModel.changes.properties!.add(property);
      } else {
        newMetadataModel.unchanged.properties!.add(property);
      }
    }

    for (var widget in generalFiles.widgets!) {
      if (!item.widgets!.contains(widget)) {
        newMetadataModel.changes.widgets!.add(widget);
      } else {
        newMetadataModel.unchanged.widgets!.add(widget);
      }
    }

    for (var screen in generalFiles.screens!) {
      if (!item.screens!.contains(screen)) {
        newMetadataModel.changes.screens!.add(screen);
      } else {
        newMetadataModel.unchanged.screens!.add(screen);
      }
    }

    return newMetadataModel;
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
    if (lines.any((item) => RegExp(r'\d').hasMatch(item))) {
      lines.add(',');
    }

    json = '"${DateTime.now().toString()}": $json';

    lines.add(json);
    lines.add('}');
    await File(filePath).writeAsString(lines.join('\n'));
  }
}
