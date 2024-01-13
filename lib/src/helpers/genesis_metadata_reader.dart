import 'dart:io';

import 'package:genesis/src/features/error_control/exceptions.dart';

class GMetadataReader {
  final String _genesisMetadataPath = 'lib/src/genesis.gs.metadata';

  static Map<String, String> generatePaths = {};
  static Map<String, String> paths = {};
  static Map<String, String> removePaths = {};
  static Map<String, String> properties = {};
  static Map<String, String> removeProperties = {};

  GMetadataReader() {
    _readGenesisMetadata();
  }

  void _readGenesisMetadata() {
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
          List<String> lineSplit = line.replaceAll('$sign  ', '').split(' -> ');
          _createRoute(lineSplit, sign: sign);
        }
      }
    } else {
      Exceptions().throwErrorEmptyMetadata();
    }
  }

  void _createRoute(List<String> lineSplit, {String sign = '+'}) {
    String key = lineSplit[0];
    String value = 'lib/${lineSplit[1]}';

    if (key == 'g') {
      _updatePaths(sign, key, value, generatePaths, removePaths);
      return;
    }

    if (lineSplit.length == 1) return;

    if (key.split(' ')[1] == 'p') {
      _updatePaths(sign, key, value, properties, removeProperties);
    } else {
      value = _calculateValue(key, lineSplit[1]);
      _updatePaths(sign, key, value, paths, removePaths);
    }
  }

  void _updatePaths(String sign, String key, String value,
      Map<String, String> addPath, Map<String, String> removePath) {
    if (sign == '+') {
      addPath.addAll({key: value});
    } else {
      addPath.remove(key);
      removePath.addAll({key: value});
    }
  }

  String _calculateValue(String key, String lineSplit) {
    String value = '';
    int keyInt = int.parse(key);
    if (paths.isNotEmpty &&
        int.parse(paths.entries.last.key.split(' ')[0]) < keyInt) {
      value = '${paths[paths.entries.last.key]}/$lineSplit';
    } else if (int.parse(paths.entries.last.key.split(' ')[0]) >= keyInt &&
        key != '0') {
      value = '${paths[_findLastFolderKey(keyInt)]}/$lineSplit';
    } else if (key == '0') {
      value = 'lib/$lineSplit';
    }
    return value;
  }

  String _findLastFolderKey(int keyInt) {
    return paths.entries
        .lastWhere((element) =>
            int.parse(element.key.split(' ')[0]) < keyInt &&
            element.key.contains('Folder'))
        .key;
  }
}
