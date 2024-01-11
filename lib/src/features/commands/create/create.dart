import 'dart:io';

import 'package:genesis/src/features/commands/create/generate_model.dart';
import 'package:genesis/src/features/error_control/genesis_create_exception.dart';
import 'package:genesis/src/helpers/console_color.dart';

class Create {
  create(List<String> arguments) {
    if (arguments.isEmpty) {
      File genesisFile = File('genesis/genesis.gs');
      if (!genesisFile.existsSync()) {
        stdout.write(ConsoleColor.penError(
            'The genesis.gs file does not exist. Please, run the command `genesis init` to create it'));
        return;
      }
      stdout.write(ConsoleColor.penInfo('Reading the genesis.gs file...\n'));
      String genesisFileRead = _readGenesisFile(genesisFile);
      if (genesisFileRead == '') {
        return;
      }
      stdout.write(ConsoleColor.penSuccess('genesis.gs read successfully\n'));
      stdout.write(
          ConsoleColor.penInfo('Writing the genesis.gs.metadata file...\n'));
      String genesisMetadata = _writeGenesisMetadata(genesisFileRead);
      if (genesisMetadata == '') {
        return;
      }
      stdout.write(ConsoleColor.penSuccess(
          'genesis.gs.metadata written successfully\n'));
      stdout.write(ConsoleColor.penInfo('Creating the project structure...\n'));
    }
  }

  String _readGenesisFile(File genesisFile) {
    String genesisFileRead = '';
    try {
      genesisFileRead = genesisFile.readAsStringSync();
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while reading the genesis.gs file\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return '';
    }
    stdout.write(
        ConsoleColor.penSuccess('genesis.gs file was read successfully\n'));
    return genesisFileRead;
  }

  String _writeGenesisMetadata(String genesisFileRead) {
    File genesisMetadata = File('genesis/genesis_metadata.gs');
    String metadataString = '';
    String metadataStringOld = '';
    try {
      List<String> genesisFileReadList = [];
      bool skip = false;
      int tabulationCount = 0;
      int generationFileTabulation = 0;
      int linesCount = 0;
      int skipTabulationCount = 0;
      for (var row in genesisFileRead.split('\n')) {
        linesCount++;

        tabulationCount = row.replaceAll(RegExp('[^_]'), '').length;

        if (tabulationCount == generationFileTabulation &&
            tabulationCount != 0) {
          genesisFileReadList.removeLast();
        }

        if (row.contains('!')) {
          skip = true;
          skipTabulationCount = tabulationCount;
        } else if (tabulationCount == skipTabulationCount) {
          skip = false;
        }
        if (row.trim().isNotEmpty) {
          if ((row.trim().split(' ')[0] != '--') && !skip) {
            List<String> rowList = row.trim().replaceAll('_', '').split(' ');
            if (!row.contains('_')) {
              if (row.contains('-')) {
                throw GenesisCreateException(
                    'Cannot declare a property at the top of the order.\n'
                    'Please, declare the property inside a folder or file\n',
                    stackTrace: '-> Error at line $linesCount\n'
                        ' -> Error at column ${row.indexOf('-')}');
              }
              genesisFileReadList = [];
              genesisFileReadList.add(rowList[0]);

              metadataString += addFileFolder(metadataString, rowList, 0);
            } else {
              if (row.contains('*')) {
                genesisFileReadList.add(rowList[0]);
                generationFileTabulation = tabulationCount;
                metadataString +=
                    'g -> ${rowList[0]} -> ${genesisFileReadList.join('/')}\n';
                metadataString +=
                    addFileFolder(metadataString, rowList, tabulationCount);
              } else {
                if (rowList.contains('-')) {
                  if (rowList.length < 3) {
                    throw GenesisCreateException(
                        'Cannot declare a property without a type or name.\n',
                        stackTrace: '-> Error at line $linesCount'
                            ' -> Error at column ${row.indexOf('-')}');
                  }
                  metadataString +=
                      '$tabulationCount p -> ${rowList[1]} ${rowList[2]} ${rowList.length > 2 ? 'NotNullable' : 'Nullable'}\n';
                } else {
                  metadataString +=
                      addFileFolder(metadataString, rowList, tabulationCount);
                }
                if (rowList.contains('F')) {
                  genesisFileReadList.add(rowList[0]);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while writing the genesis_metadata.gs file\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return '';
    }
    genesisMetadata.createSync();
    metadataStringOld = genesisMetadata.readAsStringSync();
    metadataString = _checkMetadataChanges(metadataStringOld, metadataString);
    genesisMetadata.writeAsStringSync(metadataString, mode: FileMode.append);
    return metadataString;
  }

  String addFileFolder(
      String metadataString, List<String> rowList, int tabulationCount) {
    return rowList[1] == 'F'
        ? '$tabulationCount Folder -> ${rowList[0]}\n'
        : '$tabulationCount File -> ${rowList[0]}.dart ${rowList.length > 2 ? 'NoDatabase' : 'Database'}\n';
  }

  String _checkMetadataChanges(String oldString, String newString) {
    String metadata = '';
    String oldMetadataCustom =
        oldString.replaceAll('+ ', '').replaceAll('= ', '');

    List<String> newData = newString.trim().split('\n');
    List<String> oldDataAll = oldMetadataCustom.trim().split('---\n');
    List<String> oldData =
        oldDataAll[oldDataAll.length - 1].replaceAll('-! ', '').split('\n');
    List<String> oldDataNonReplaced =
        oldDataAll[oldDataAll.length - 1].split('\n');

    stdout.writeln(oldData.join());

    if (oldData.join().trim().toLowerCase() == newString.trim().toLowerCase()) {
      for (var line in newData) {
        metadata += '= $line\n';
      }
    } else if (oldString == '') {
      for (var line in newData) {
        metadata += '+ $line\n';
      }
    } else {
      for (var line in newData) {
        if (!oldData.contains(line)) {
          metadata += '+ $line\n';
        } else {
          if (!oldDataNonReplaced.contains('-! $line')) {
            metadata += '= $line\n';
          } else {
            metadata += '+ $line\n';
          }
        }
      }
      for (var line in oldData) {
        if (!newData.contains(line) &&
            line != '' &&
            !line.contains('---') &&
            !line.contains(':')) {
          metadata += '-! $line\n';
        }
      }
    }

    metadata += '${DateTime.now()}\n---\n';
    return metadata;
  }

  // void _createProjectStructure(String genesisMetadata) {
  //   List<String> genesisMetadataList = genesisMetadata.split('\n');
  //   int tabulationCount = 0;
  //   int firstTabulation = 0;

  // }

  void _createFolder(String folderName, {bool createBarrelFile = true}) {
    Directory folder = Directory(folderName);
    try {
      folder.createSync();
      if (createBarrelFile) {
        _createFile('$folderName/$folderName.dart',
            content:
                'This is a barrel file, you can export all the files inside this folder\n'
                'By default Genesis will export here all the files that you create with the command on this folder $folderName\n\n');
      }
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while creating the folder `$folderName`\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return;
    }
  }

  void _createFile(String fileName, {String content = ''}) {
    File file = File(fileName);
    try {
      file.createSync();
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while creating the file `$fileName`\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return;
    }
    if (content != '') {
      try {
        file.writeAsStringSync(content);
      } catch (e) {
        stdout.write(ConsoleColor.penError(
            'An error occurred while writing the file `$fileName`\n'));
        stdout.write(ConsoleColor.penError(e.toString()));
        return;
      }
    }
  }

  void _createModel(
      String modelFileName, Map<String, String> properties, bool database) {
    String modelName = modelFileName.split('/').last.split('.').first;
    _createFile(modelFileName, content: '''
import 'dart:convert';

@reflector
class $modelName extends Dao {
  $modelName();

  $modelName.all({${GenerateModel().generateModelConstructor(properties)}});

  ${GenerateModel().generateModelProperties(properties)}

  factory $modelName.fromRawJson(String str) => $modelName.fromJson(json.decode(str));

  factory $modelName.fromJson(Map<String, dynamic> json) => $modelName.all(
        ${GenerateModel().generateFromJson(properties)}
  );

  Map<String, dynamic> toJson() => {
        ${GenerateModel().generateToJson(properties)}
  };
  ${GenerateModel().generateDatabaseMethods(database, properties)}
  static final Map<String, String> _fields = {
    'nr': Constants.bigint,
    'name': Constants.varchar['20']!,
    'date': Constants.datetime,
    'price': Constants.decimal['9,2']!
  };


  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [_names.elementAt(0)];
  static final List<String> _exception = [_names.elementAt(3)];

  static final List<String> _foreign = [];

  static List<String> get foreign => _foreign;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get primary => _primary;

  static List<String> get exception => _exception;

  @override
  bool operator ==(Object other) {
    //TODO: Customize the operator == to your needs
    if (identical(this, other)) return true;

    return other is Model && other.nr == nr;
  }

  @override
  int get hashCode {
    //TODO: Customize the hashCode to your needs
    return nr.hashCode;
  }
}
''');
  }

  void createReflectionNeeds() {
    String builderRoute = 'lib/builder.dart';
    String builderContent = '''
import 'package:reflectable/reflectable_builder.dart' as builder;

main(List<String> arguments) async {
  await builder.reflectableBuild(arguments);
}
''';

    String buildYamlRoute = 'build.yaml';
    //TODO: Use the model route in el generate_for of the build.yaml
    String buildYamlContent = '''
targets:
  \$default:
    builders:
      reflectable:
        generate_for:
          - lib/database/entity/**.dart # Here your entity directory
        options:
          formatted: true
''';

    File builderFile = File(builderRoute);
    File buildYamlFile = File(buildYamlRoute);

    builderFile.writeAsStringSync(builderContent);
    buildYamlFile.writeAsStringSync(buildYamlContent);
  }

  // void _createCubit(String cubitName) {}

  // void _createStateLessWidget(String stateLessWidgetName) {}

  // void _createStateFullWidget(String stateFullWidgetName) {}
}
