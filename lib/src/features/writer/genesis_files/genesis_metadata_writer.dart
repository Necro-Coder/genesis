import 'dart:convert';
import 'dart:io';

import 'package:genesis/src/features/reader/genesis_data_reader.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/genesis_metadata_reader.dart';
import 'package:genesis/src/features/reader/models/common.dart';
import 'package:genesis/src/features/reader/models/files/genesis_general_file.dart';

class GMetadataWriter {
  final GDataReader _reader = GDataReader();
  final GMetadataReader _metadataReader = GMetadataReader();

  final Map<String, List<Common>> _changes = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  final Map<String, List<Common>> _deletions = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  final Map<String, List<Common>> _unchanged = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  Future<void> writeMetadata() async {
    File genesisMetadata = File('lib/genesis/genesis.metadata.json');
    try {
      if (!genesisMetadata.existsSync()) {
        await genesisMetadata.create();
        await genesisMetadata.writeAsString('{\n\n}');
      }
    } catch (e) {
      rethrow;
    }
    await _reader.readData();
    String metadata = await _metadataReader.read();

    _checkChanges(metadata);
    List<String> lines = await genesisMetadata.readAsLines();
    lines.removeLast();
    await genesisMetadata.writeAsString(lines.join('\n'), mode: FileMode.write);
    await genesisMetadata.writeAsString('\n"${DateTime.now()}": {',
        mode: FileMode.append);
    await _writeChanges(genesisMetadata);
    await _writeUnchanged(genesisMetadata);
    await _writeDeletions(genesisMetadata);

    await genesisMetadata.writeAsString('\n}}', mode: FileMode.append);
  }

  void _checkChanges(String metadata) {
    Map<String, dynamic> json = jsonDecode(metadata);
    GeneralFile generalFile = GeneralFile.fromJson(json);

    Map<String, dynamic> itemsMap = {
      'file': GFileList(),
      'folder': GFolderList(),
      'property': GPropertyList(),
      'screen': GScreenList(),
      'widget': GWidgetList(),
    };

    Map<String, dynamic> generalFileMap = {
      'file': generalFile.files,
      'folder': generalFile.folders,
      'property': generalFile.properties,
      'screen': generalFile.screens,
      'widget': generalFile.widgets,
    };

    for (var key in itemsMap.keys) {
      _checkItems(key, generalFileMap[key] ?? [], itemsMap[key]);
    }
  }

  void _checkItems(String key, List<Common> generalItems, dynamic list) {
    for (var item in generalItems) {
      if (list.commons.contains(item)) {
        _unchanged[key]!.add(item);
      } else if (!list.commons.contains(item)) {
        _changes[key]!.add(item);
      }
    }

    for (var item in list.commons) {
      if (!generalItems.contains(item)) {
        _deletions[key]!.add(item);
      }
    }
  }

  Future<void> _writeChanges(File genesisMetadata) async {
    await _writeDataToFile(genesisMetadata, _changes, 'Changes');
    stdout.writeln('$_changes');
  }

  Future<void> _writeUnchanged(File genesisMetadata) async {
    await _writeDataToFile(genesisMetadata, _unchanged, 'Unchanged');
    stdout.writeln('$_unchanged');
  }

  Future<void> _writeDeletions(File genesisMetadata) async {
    await _writeDataToFile(genesisMetadata, _deletions, 'Deletions');
    stdout.writeln('${_deletions.length}');
  }

  Future<void> _writeDataToFile(File genesisMetadata,
      Map<String, List<Common>> dataMap, String type) async {
    var keys = ['folder', 'file', 'property', 'screen', 'widget'];
    int count = 0;
    for (var x in keys) {
      if (dataMap[x]!.isNotEmpty) {
        count++;
      }
    }
    try {
      await genesisMetadata.writeAsString('"$type":{\n', mode: FileMode.append);
      int i = 0;
      for (var key in keys) {
        for (var item in dataMap[key] ?? []) {
          await _writeData(genesisMetadata, item, type,
              dataMap[key]!.last == item || i == count);
        }
        i++;
      }
      await genesisMetadata.writeAsString(
          '\n}${type == 'Deletions' ? '' : ','}',
          mode: FileMode.append);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _writeData(
      File genesisMetadata, Common item, String type, bool last) async {
    await genesisMetadata.writeAsString(
        '\n"${item.path!.trim()}": ${jsonEncode(item.toJson())}${last ? '' : ','}',
        mode: FileMode.append);
  }
}
