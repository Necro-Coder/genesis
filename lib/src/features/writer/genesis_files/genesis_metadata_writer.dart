import 'dart:convert';
import 'dart:io';

import 'package:genesis/src/features/reader/genesis_data_reader.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/genesis_metadata_reader.dart';
import 'package:genesis/src/features/reader/models/common.dart';
import 'package:genesis/src/features/reader/models/genesis_general_file.dart';

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
    await _reader.readData();
    String metadata = await _metadataReader.read();

    _checkChanges(metadata);

    await _writeChanges(genesisMetadata);
    await _writeUnchanged(genesisMetadata);
    await _writeDeletions(genesisMetadata);

    await genesisMetadata.writeAsString('\n${DateTime.now()}\n---\n',
        mode: FileMode.append);
  }

  void _checkChanges(String metadata) {
    GeneralFile generalFile = GeneralFile.fromJson(jsonDecode(metadata));

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
      _checkItems(key, generalFileMap[key]!, itemsMap[key]);
    }
  }

  void _checkItems(String key, List<Common> generalItems, GCommonList list) {
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
  }

  Future<void> _writeUnchanged(File genesisMetadata) async {
    await _writeDataToFile(genesisMetadata, _unchanged, 'Unchanged');
  }

  Future<void> _writeDeletions(File genesisMetadata) async {
    await _writeDataToFile(genesisMetadata, _deletions, 'Deletions');
  }

  Future<void> _writeDataToFile(File genesisMetadata,
      Map<String, List<Common>> dataMap, String type) async {
    var keys = ['folder', 'file', 'property', 'screen', 'widget'];

    for (var key in keys) {
      for (var item in dataMap[key]!) {
        await _writeData(genesisMetadata, item, type);
      }
    }
  }

  Future<void> _writeData(
      File genesisMetadata, Common item, String type) async {
    await genesisMetadata.writeAsString('$type\n${jsonEncode(item.toJson())}',
        mode: FileMode.append);
  }
}
