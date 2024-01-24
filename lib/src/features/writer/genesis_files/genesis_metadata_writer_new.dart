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

    GMetadataModel newMetadataModel = await _checkForDeletions(
        generalFiles,
        metadataModel.changes,
        metadataModel.unchanged,
        await _compareLists(
            generalFiles, metadataModel.changes, metadataModel.unchanged));
    if (_firstWrite) {
      newMetadataModel.changes = generalFiles;
      newMetadataModel.deletions = GeneralFile(
        files: [],
        folders: [],
        properties: [],
        widgets: [],
        screens: [],
      );
      newMetadataModel.unchanged = GeneralFile(
        files: [],
        folders: [],
        properties: [],
        widgets: [],
        screens: [],
      );
    }
    await _writeMetadata(newMetadataModel);
  }

  Future<GMetadataModel> _compareLists(GeneralFile generalFiles,
      GeneralFile itemChanges, GeneralFile itemUnchanged) async {
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

    if (itemChanges.files == null) {
      return newMetadataModel;
    }

    _compareAndAddToLists(
        generalFiles.files,
        itemChanges.files,
        itemUnchanged.files,
        newMetadataModel.changes.files,
        newMetadataModel.unchanged.files);
    _compareAndAddToLists(
        generalFiles.folders,
        itemChanges.folders,
        itemUnchanged.folders,
        newMetadataModel.changes.folders,
        newMetadataModel.unchanged.folders);
    _compareAndAddToLists(
        generalFiles.properties,
        itemChanges.properties,
        itemUnchanged.properties,
        newMetadataModel.changes.properties,
        newMetadataModel.unchanged.properties);
    _compareAndAddToLists(
        generalFiles.widgets,
        itemChanges.widgets,
        itemUnchanged.widgets,
        newMetadataModel.changes.widgets,
        newMetadataModel.unchanged.widgets);
    _compareAndAddToLists(
        generalFiles.screens,
        itemChanges.screens,
        itemUnchanged.screens,
        newMetadataModel.changes.screens,
        newMetadataModel.unchanged.screens);

    return newMetadataModel;
  }

  Future<GMetadataModel> _checkForDeletions(
      GeneralFile generalFiles,
      GeneralFile changes,
      GeneralFile unchanged,
      GMetadataModel newMetadataModel) async {
    await _checkListForDeletions(generalFiles.files, changes.files,
        unchanged.files, newMetadataModel.deletions.files);

    await _checkListForDeletions(generalFiles.folders, changes.folders,
        unchanged.folders, newMetadataModel.deletions.folders);

    await _checkListForDeletions(generalFiles.properties, changes.properties,
        unchanged.properties, newMetadataModel.deletions.properties);

    await _checkListForDeletions(generalFiles.widgets, changes.widgets,
        unchanged.widgets, newMetadataModel.deletions.widgets);

    await _checkListForDeletions(generalFiles.screens, changes.screens,
        unchanged.screens, newMetadataModel.deletions.screens);

    return newMetadataModel;
  }

  Future<void> _checkListForDeletions(
      List<dynamic>? generalList,
      List<dynamic>? changesList,
      List<dynamic>? unchangedList,
      List<dynamic>? deletionsList) async {
    if (generalList != null && changesList != null && unchangedList != null) {
      for (var element in changesList) {
        if (!generalList.contains(element)) {
          deletionsList!.add(element);
        }
      }
      for (var element in unchangedList) {
        if (!generalList.contains(element)) {
          deletionsList!.add(element);
        }
      }
    }
  }

  void _compareAndAddToLists(
      List<dynamic>? generalList,
      List<dynamic>? itemListChanges,
      List<dynamic>? itemListUnchanged,
      List<dynamic>? changesList,
      List<dynamic>? unchangedList) {
    if (generalList != null &&
        itemListChanges != null &&
        changesList != null &&
        unchangedList != null) {
      for (var element in generalList) {
        if (!itemListChanges.contains(element) &&
            !itemListUnchanged!.contains(element)) {
          changesList.add(element);
        } else {
          unchangedList.add(element);
        }
      }
    }
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
