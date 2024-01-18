import 'dart:io';

import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/features/reader/genesis_file_lists.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_screen_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_properties_model.dart';
import 'package:genesis/src/features/reader/models/project/genesis_folder_model.dart';

class GDataReader {
  static final Map<String, String> paths = {};

  Future<void> readData() async {
    File genesisFile = File('lib/genesis/genesis.gs');
    List<String> lines = await genesisFile.readAsLines();

    int tabulation = 0;

    for (var line in lines) {
      tabulation = _countLeadingTabulations(line);
      if (line.contains('(f)')) {
        _readFolder(line, tabulation);
      } else if (line.contains('(d)')) {
        _readFile(line, tabulation);
      } else if (line.contains('(p)')) {
        _readProperty(line, tabulation);
      } else if (line.contains('(s)')) {
        _readScreen(line, tabulation);
      } else if (line.contains('(w)')) {
        _readWidget(line, tabulation);
      } else {
        Exceptions().throwErrorNoType(line.split(' ')[0]);
      }
    }
  }

  void _readFolder(String line, int tabulation) {
    GFolder folder = GFolder();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      if (part.contains('name')) {
        folder.name = part.split(':')[1];
      } else if (part.contains('*')) {
        folder.isGeneration = true;
      } else {
        Exceptions().throwErrorFolderNoName();
      }
    }

    folder.path = _getPath(tabulation, folder.name!, 'f');
    GFolderList().add(folder);
  }

  void _readFile(String line, int tabulation) {
    GFile file = GFile();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      if (part.contains('name')) {
        file.name = part.split(':')[1];
      } else {
        Exceptions().throwErrorModelNoName();
      }
    }

    file.path = _getPath(tabulation, file.name!, 'd');
    GFileList().add(file);
  }

  void _readProperty(String line, int tabulation) {
    GProperty property = GProperty();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      if (part.contains('name')) {
        property.name = part.split(':')[1];
      } else if (!part.contains('name')) {
        Exceptions().throwErrorPropertyNoName();
      } else if (part.contains('type')) {
        property.type = part.split(':')[1];
      } else if (part.contains('primary')) {
        property.isPrimary = part.split(':')[1] == 'true';
      } else if (!part.contains('primary') && part.contains('foreign')) {
        property.isForeign = part.split(':')[1] == 'true';
      } else if (part.contains('foreign') && part.contains('table')) {
        property.table = part.split(':')[1];
      } else if (part.contains('foreign') && !part.contains('table')) {
        Exceptions().throwErrorNoTableForeign(property.name!);
      }
    }

    property.path = _getPath(tabulation, property.name!, 'p');
    GPropertyList().add(property);
  }

  void _readScreen(String line, int tabulation) {
    GScreen screen = GScreen();

    List<String> parts = line.split(', ');
    bool templateOrState = false;
    for (var part in parts) {
      var splitPart = part.split(':');
      var key = splitPart[0];
      var value = splitPart.length > 1 ? splitPart[1] : null;

      if (key == 'name') {
        screen.name = value;
        if (value == null) {
          Exceptions().throwErrorScreenNoName();
        }
      } else if (key == 'template') {
        screen.template = value;
        templateOrState = true;
      } else if (key == 'state' && !part.contains('template')) {
        screen.isStateful = value == 'true';
        templateOrState = true;
      }
    }

    if (!templateOrState) {
      Exceptions().throwErrorNoStateTemplate(screen.name!);
    } else {
      screen.path = _getPath(tabulation, screen.name!, 'd');
      GScreenList().add(screen);
    }
  }

  void _readWidget(String line, int tabulation) {
    GWidget widget = GWidget();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      var splitPart = part.split(':');
      var key = splitPart[0];
      var value = splitPart.length > 1 ? splitPart[1] : null;

      if (key == 'name') {
        widget.name = value;
        if (value == null) {
          Exceptions().throwErrorScreenNoName();
        }
      } else if (key == 'template') {
        widget.template = value;
      }
    }

    widget.path = _getPath(tabulation, widget.name!, 'd');
    GWidgetList().add(widget);
  }

  String _getPath(int tabulation, String name, String type) {
    if (tabulation == 0 && type == 'f') {
      paths.addAll({'lib/$name': '0-$type'});
    } else if (tabulation == 0 && type != 'f') {
      Exceptions().throwTabErrorOnFile();
    } else {
      var lastPath = _getLastPathWithF(tabulation - 1);
      if (lastPath != null) {
        paths.addAll({
          '$lastPath/$name${type == 'd' ? '.dart' : ''}': '$tabulation-$type'
        });
      } else {
        Exceptions().throwErrorNeedUpperFolder(name);
      }
    }
    return paths.keys.last;
  }

  String? _getLastPathWithF(int tabulation) {
    for (var entry in paths.entries.toList().reversed) {
      if (entry.value == '$tabulation-F') {
        return entry.key;
      }
    }
    return null;
  }

  int _countLeadingTabulations(String line) {
    int count = 0;
    while (line.startsWith('\t') || line.startsWith('    ')) {
      count++;
      line = line.substring(1);
    }
    return count;
  }
}
