import 'dart:convert';

import 'package:genesis/src/features/reader/genesis_data_reader.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/genesis_metadata_reader.dart';
import 'package:genesis/src/features/reader/models/common.dart';
import 'package:genesis/src/features/reader/models/genesis_general_file.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';

class GMetadataWriter {
  final GDataReader _reader = GDataReader();
  final GMetadataReader _metadataReader = GMetadataReader();

  final Map<String, List<String>> _changes = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  final Map<String, List<String>> _deletions = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  final Map<String, List<String>> _noChanges = {
    'file': [],
    'folder': [],
    'property': [],
    'screen': [],
    'widget': [],
  };

  Future<void> writeMetadata() async {
    await _reader.readData();
    String metadata = await _metadataReader.read();

    _checkChanges(metadata);

    _writeFiles();
    // _writeFolders();
    // _writeProperties();
    // _writeScreens();
    // _writeWidgets();
  }

  void _checkChanges(String metadata) {
    GeneralFile generalFile = GeneralFile.fromJson(jsonDecode(metadata));
    GFileList filesList = GFileList();
    GFolderList foldersList = GFolderList();
    GPropertyList propertiesList = GPropertyList();
    GScreenList screensList = GScreenList();
    GWidgetList widgetsList = GWidgetList();

    _checkItems('file', generalFile.files!, filesList);
    _checkItems('folder', generalFile.folders!, foldersList);
    _checkItems('property', generalFile.properties!, propertiesList);
    _checkItems('screen', generalFile.screens!, screensList);
    _checkItems('widget', generalFile.widgets!, widgetsList);
  }

  void _checkItems(String key, List<Common> generalItems, GCommonList list) {
    for (var item in generalItems) {
      if (list.commons.contains(item)) {
        _noChanges[key]!.add(item.name!);
      } else if (!list.commons.contains(item)) {
        _changes[key]!.add(item.name!);
      }
    }

    for (var item in list.commons) {
      if (!generalItems.contains(item)) {
        _deletions[key]!.add(item.name!);
      }
    }
  }

  void _writeFiles() {
    for (var file in _changes['file']!) {
      GeneralFile generalFile = GeneralFile();
      generalFile.files = [GFile(name: file)];
    }
  }
}
