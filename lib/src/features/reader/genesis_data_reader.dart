import 'dart:io';

import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/features/error_control/genesis_exception.dart';
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

    lines.remove(lines.last);

    bool comment = false;
    int counter = 0;
    List<String> errors = [];

    for (var line in lines) {
      try {
        counter++;
        if (line.startsWith('--') && !line.startsWith('--!')) continue;
        if (line.startsWith('!--') || comment) {
          comment = true;
          if (line.startsWith('--!')) {
            comment = false;
          }
          continue;
        }
        if (line.isEmpty) continue;

        tabulation = _countLeadingTabulations(line);
        if (line.contains('(f)')) {
          _readFolder(line, tabulation, counter);
        } else if (line.contains('(d)')) {
          _readFile(line, tabulation, counter);
        } else if (line.contains('(p)')) {
          _readProperty(line, tabulation, counter);
        } else if (line.contains('(s)')) {
          _readScreen(line, tabulation, counter);
        } else if (line.contains('(w)')) {
          _readWidget(line, tabulation, counter);
        } else {
          Exceptions().throwErrorNoType(line.split(' ')[0]);
        }
      } catch (e) {
        errors.add(e.toString());
      }
    }
    if (errors.isNotEmpty) {
      throw GenesisException(errors.join('\n'));
    }
  }

  void _readFolder(String line, int tabulation, int counter) {
    GFolder folder = GFolder();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      if (part.contains('name')) {
        folder.name = part.split(':')[1];
      } else if (part.contains('*')) {
        folder.isGeneration = true;
      } else {
        Exceptions().throwErrorFolderNoName(line: counter, content: line);
      }
    }

    folder.path = _getPath(
        tabulation, folder.name!.replaceAll(' ', ''), 'f', counter, line);
    GFolderList().add(folder);
  }

  void _readFile(String line, int tabulation, int counter) {
    GFile file = GFile();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      if (part.contains('name')) {
        file.name = part.split(':')[1];
      } else {
        Exceptions().throwErrorModelNoName();
      }
    }

    file.path = _getPath(
        tabulation, file.name!.replaceAll(' ', ''), 'd', counter, line);
    GFileList().add(file);
  }

  void _readProperty(String line, int tabulation, int counter) {
    GProperty property = GProperty();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      part = part.trim();
      if (part.contains('name')) {
        property.name = part.split(':')[1];
        continue;
      } else if (!part.contains('name') && property.name == null) {
        Exceptions().throwErrorPropertyNoName(line: counter, content: line);
      } else if (part.contains('type')) {
        property.type = part.split(':')[1];
      } else if (part.contains('primary')) {
        property.isPrimary = part.split(':')[1] == 'true';
      } else if (!part.contains('primary') && part.contains('foreign')) {
        property.isForeign = part.split(':')[1] == 'true';
      } else if (part.contains('foreign') && part.contains('table')) {
        property.table = part.split(':')[1];
      } else if (part.contains('foreign') && !part.contains('table')) {
        Exceptions().throwErrorNoTableForeign(property.name!,
            line: counter, content: line);
      }
    }

    property.path = _getPath(
        tabulation, property.name!.replaceAll(' ', ''), 'p', counter, line);
    GPropertyList().add(property);
  }

  void _readScreen(String line, int tabulation, int counter) {
    GScreen screen = GScreen();

    List<String> parts = line.split(', ');
    bool templateOrState = false;
    for (var part in parts) {
      var splitPart = part.split(':');
      var key = splitPart[0];
      var value = splitPart.length > 1 ? splitPart[1] : null;

      if (key.contains('name')) {
        screen.name = value;
        if (value == null) {
          Exceptions().throwErrorScreenNoName(line: counter, content: line);
        }
      } else if (key.contains('template')) {
        screen.template = value;
        templateOrState = true;
      } else if (key.contains('state') && !part.contains('template')) {
        screen.isStateful = value == 'true';
        templateOrState = true;
      }
    }

    if (!templateOrState) {
      Exceptions().throwErrorNoStateTemplate(screen.name!,
          line: counter, content: line);
    } else {
      screen.path = _getPath(
          tabulation, screen.name!.replaceAll(' ', ''), 'd', counter, line);
      GScreenList().add(screen);
    }
  }

  void _readWidget(String line, int tabulation, int counter) {
    GWidget widget = GWidget();

    List<String> parts = line.split(', ');
    for (var part in parts) {
      var splitPart = part.split(':');
      var key = splitPart[0].trim();
      var value = splitPart.length > 1 ? splitPart[1].trim() : null;

      if (key.contains('name')) {
        widget.name = value;
        if (value == null) {
          Exceptions().throwErrorWidgetNoName(line: counter, content: line);
        }
      } else if (key.contains('template')) {
        widget.template = value;
      }
    }

    widget.path = _getPath(
        tabulation, widget.name!.replaceAll(' ', ''), 'd', counter, line);
    GWidgetList().add(widget);
  }

  String _getPath(
      int tabulation, String name, String type, int counter, String line) {
    if (tabulation == 0 && type == 'f') {
      paths.addAll({'lib/$name': '0-$type'});
    } else if (tabulation == 0 && type != 'f') {
      Exceptions().throwTabErrorOnFile(line: counter, content: line);
    } else {
      if (type == 'p') {
        paths.addAll({
          '${_getLastPathWithD(tabulation - 1)}/$name.dart': '$tabulation-$type'
        });
      } else {
        var lastPath = _getLastPathWithF(tabulation - 1);
        if (lastPath != null) {
          paths.addAll({
            '$lastPath/$name${type == 'd' ? '.dart' : ''}': '$tabulation-$type'
          });
        } else {
          Exceptions()
              .throwErrorNeedUpperFolder(name, line: counter, content: line);
        }
      }
    }
    return paths.keys.last;
  }

  String? _getLastPathWithF(int tabulation) {
    for (var entry in paths.entries.toList().reversed) {
      if (entry.value == '$tabulation-f') {
        return entry.key;
      }
    }
    return null;
  }

  String? _getLastPathWithD(int tabulation) {
    for (var entry in paths.entries.toList().reversed) {
      if (entry.value == '$tabulation-D') {
        return entry.key;
      }
    }
    return null;
  }

  int _countLeadingTabulations(String line) {
    int count = 0;
    while (line.startsWith('    ')) {
      count++;
      line = line.substring(4);
    }
    return count;
  }
}
