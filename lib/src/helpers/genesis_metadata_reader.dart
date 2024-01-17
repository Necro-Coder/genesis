import 'dart:io';

import 'package:genesis/src/features/error_control/exceptions.dart';

class GMetadataReader {
  final String _genesisMetadataPath = 'lib/genesis/genesis.gs.metadata';

  static Map<String, String> generatePaths = {};
  static Map<String, String> paths = {};
  static Map<String, String> removePaths = {};
  static Map<String, String> properties = {};
  static Map<String, String> removeProperties = {};

  GMetadataReader();

  Future<void> readGenesisMetadata() async {
    File file = File(_genesisMetadataPath);
    if (!file.existsSync()) {
      file.createSync();
    }
    String content = file.readAsStringSync();
    removePaths = {};

    if (content.isNotEmpty) {
      List<String> lines = content.split('\n');
      for (var line in lines) {
        if (line.isNotEmpty) {
          String sign = line.split(' ')[0];
          List<String> lineSplit = line.replaceAll('$sign ', '').split(' ->');
          _createRoute(lineSplit, sign: sign);
        }
      }
    } else {
      Exceptions().throwErrorEmptyMetadata();
    }
  }

  void _createRoute(List<String> lineSplit, {String sign = '+'}) {
    String key = lineSplit[0].split(' ')[0];

    if (lineSplit.length == 1) return;

    String value = 'lib/${lineSplit[1]}';

    if (key == 'g') {
      _updatePaths(sign, key, value.replaceAll(' ', ''), 'generatePaths');
      return;
    }

    if (lineSplit[0].split(' ')[1] == 'p') {
      _updatePaths(sign, key, value, 'properties');
    } else {
      value = _calculateValue(key, lineSplit[1]);
      _updatePaths(sign, key, value.replaceAll(' ', ''), 'paths');
    }
  }

  void _updatePaths(String sign, String key, String value, String type) {
    Map<String, Map<String, String>> collections = {
      'generatePaths': GMetadataReader.generatePaths,
      'paths': GMetadataReader.paths,
      'properties': GMetadataReader.properties,
    };

    if (collections.containsKey(type)) {
      if (sign == '+') {
        collections[type]!.addAll({key: value});
      } else {
        collections[type]!.remove(key);
        if (type == 'properties') {
          removeProperties.addAll({key: value});
        } else {
          removePaths.addAll({key: value});
        }
      }
    }
  }

  String _calculateValue(String key, String lineSplit) {
    String value = '';
    int keyInt = int.parse(key);
    if (paths.isNotEmpty &&
        int.parse(paths.entries.last.key.split(' ')[0]) < keyInt) {
      value = '${paths[paths.entries.last.key]}/$lineSplit';
    } else if (paths.isNotEmpty &&
        int.parse(paths.entries.last.key.split(' ')[0]) >= keyInt &&
        key != '0') {
      value = '${paths[_findLastFolderKey(keyInt)]}/$lineSplit';
    } else if (key == '0') {
      value = 'lib/$lineSplit';
    }
    return value;
  }

  String _findLastFolderKey(int keyInt) {
    return paths.entries
        .lastWhere((entry) => entry.key.contains('folder'),
            orElse: () => {'': ''}.entries.first)
        .key;
  }
}
