import 'dart:io';

import 'package:genesis/src/features/commands/create/generate_model.dart';
import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/features/error_control/genesis_create_exception.dart';
import 'package:genesis/src/helpers/console_color.dart';

import '../../../helpers/genesis_metadata_reader.dart';

class Create {
  final String _genesisFolderPath = 'lib/genesis';

  /// The `create` function creates a new project based on the genesis.gs file.
  ///
  /// Args:
  ///   `arguments` (List<String>): A list of arguments passed to the function.
  ///
  /// This function checks if the `arguments` list is empty. If it is, it tries to read the genesis.gs file.
  /// If the file does not exist, it prints an error message and returns.
  /// If the file exists, it reads the file and writes the genesis.gs.metadata file.
  /// If the metadata file is written successfully, it prints a success message and starts creating the project structure.
  void create(List<String> arguments) {
    if (arguments.isEmpty) {
      File genesisFile = File('$_genesisFolderPath/genesis.gs');
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

  /// The `_readGenesisFile` function reads the contents of a Genesis file.
  ///
  /// Args:
  ///   `genesisFile` (File): The Genesis file to be read.
  ///
  /// Returns:
  ///   A string containing the contents of the Genesis file.
  ///
  /// This function tries to read the `genesisFile` as a string. If it succeeds, it prints a success message and returns the contents of the file.
  /// If it fails, it throws an error using the `throwErrorReadingGenesisFile` function from the `Exceptions` class and returns an empty string.
  String _readGenesisFile(File genesisFile) {
    String genesisFileRead = '';
    try {
      genesisFileRead = genesisFile.readAsStringSync();
    } catch (e) {
      Exceptions().throwErrorReadingGenesisFile('genesis.gs', e);
      return '';
    }
    stdout.write(
        ConsoleColor.penSuccess('genesis.gs file was read successfully\n'));
    return genesisFileRead;
  }

  /// The function `_writeGenesisMetadata` generates a metadata string for a given Genesis file.
  ///
  /// Args:
  ///   `genesisFileRead` (String): The content of the Genesis file. It is used for constructing the metadata string.
  ///
  /// Returns:
  ///   The method returns a String that represents the metadata of the Genesis file.
  ///
  /// This function reads the `genesisFileRead` line by line, and for each line, it determines the level of indentation,
  /// checks for special characters, and processes the line accordingly. If an error occurs during the process,
  /// it throws an error using the `throwErrorCreatingGenesisFile` method from the `Exceptions` class and returns an empty string.
  /// After processing all lines, it creates the metadata file, reads its old content, checks for changes in the metadata,
  /// and appends the new metadata to the file. Finally, it returns the metadata string.
  String _writeGenesisMetadata(String genesisFileRead) {
    File genesisMetadata = File('$_genesisFolderPath/genesis_metadata.gs');
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
                      '$tabulationCount p -> ${rowList[1]} ${rowList[2]} ${rowList.contains('?') ? 'NotNullable' : 'Nullable'}\n';
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
      Exceptions().throwErrorCreatingGenesisFile('genesis.gs.metadata', e);
      return '';
    }
    genesisMetadata.createSync();
    metadataStringOld = genesisMetadata.readAsStringSync();
    metadataString = _checkMetadataChanges(metadataStringOld, metadataString);
    genesisMetadata.writeAsStringSync(metadataString, mode: FileMode.append);
    return metadataString;
  }

  /// The function `addFileFolder` generates a metadata string for a file or folder based on the provided row list and tabulation count.
  ///
  /// Args:
  ///   `metadataString` (String): The current metadata string. It is not used in the function, but it is part of the function signature.
  ///   `rowList` (List<String>): The list of words in the current row. It is used to determine whether the row represents a file or a folder.
  ///   `tabulationCount` (int): The level of indentation in the current row. It is used for formatting the metadata string.
  ///
  /// Returns:
  ///   The method returns a String that represents the metadata for the file or folder represented by the row list.
  ///
  /// This function checks if the second element of `rowList` is 'F'. If it is, it returns a string representing a folder.
  /// Otherwise, it returns a string representing a file. If `rowList` has more than two elements, it adds 'NoDatabase' to the file string.
  /// Otherwise, it adds 'Database'.
  String addFileFolder(
      String metadataString, List<String> rowList, int tabulationCount) {
    return rowList[1] == 'F'
        ? '$tabulationCount Folder -> ${rowList[0]}\n'
        : '$tabulationCount File -> ${rowList[0]}.dart ${rowList.length > 2 ? 'NoDatabase' : 'Database'}\n';
  }

  /// The function `_checkMetadataChanges` compares the old and new metadata strings and generates a new metadata string that represents the changes.
  ///
  /// Args:
  ///   `oldString` (String): The old metadata string. It is used for comparison with the new metadata string.
  ///   `newString` (String): The new metadata string. It is used for comparison with the old metadata string.
  ///
  /// Returns:
  ///   The method returns a String that represents the changes between the old and new metadata strings.
  ///
  /// This function first removes '+ ' and '= ' from the old metadata string. Then, it splits the old and new metadata strings into lists of lines.
  /// It also creates a list of non-replaced lines from the old metadata string. If the old and new metadata strings are equal (ignoring case),
  /// it adds '= ' before each line in the new metadata string. If the old metadata string is empty, it adds '+ ' before each line in the new metadata string.
  /// Otherwise, it checks each line in the new metadata string. If the line is not in the old metadata string, it adds '+ ' before the line.
  /// If the line is in the old metadata string but not in the list of non-replaced lines, it adds '= ' before the line.
  /// Otherwise, it adds '+ ' before the line. Then, it checks each line in the old metadata string. If the line is not in the new metadata string,
  /// is not empty, and does not contain '---' or ':', it adds '-! ' before the line. Finally, it adds the current date and time and '---\n' to the metadata string and returns it.
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

  void _createProjectStructure(String genesisMetadata) {
    GMetadataReader();
    for (var entry in GMetadataReader.generatePaths.entries) {
      if (!Directory(entry.value.split(' ')[0]).existsSync()) {
        _createFolder(GMetadataReader.generatePaths[entry.key]!);
      }
    }
    for (var entry in GMetadataReader.paths.entries) {
      if (!File(entry.value.split(' ')[0]).existsSync()) {
        if (entry.key.contains('Folder')) {
          _createFile(GMetadataReader.paths[entry.key]!);
        } else {
          String content = '';
          _createFile(GMetadataReader.paths[entry.key]!, content: content);
        }
      }
    }

    /*
    for (var entry in GMetadataReader.properties.entries) {
      if (File(entry.key.split(' ')[0]).existsSync()) {
        _createModel(GMetadataReader.properties[entry.key]!,
            GMetadataReader.properties, true);
      }
    }
    */

    for (var entry in GMetadataReader.removePaths.entries) {
      if (File(entry.value.split(' ')[0]).existsSync()) {
        File(entry.value.split(' ')[0]).deleteSync();
      }
    }
  }

  /// The function `_createFolder` creates a new directory with the given `folderName` and optionally a barrel file inside it.
  ///
  /// Args:
  ///   `folderName` (String): The name of the folder to be created.
  ///   `createBarrelFile` (bool, optional): A flag indicating whether to create a barrel file inside the new folder. Default value is true.
  ///
  /// This function first creates a `Directory` object with the given `folderName`. Then, it tries to create the folder synchronously.
  /// If `createBarrelFile` is true, it also creates a barrel file inside the new folder with a default content.
  /// If an error occurs during the process, it calls the `throwErrorCreatingFolder` method from an instance of the `Exceptions` class, passing the `folderName` as an argument.
  /// This method throws a `GenesisCreateException` with a custom message. After throwing the exception, the function returns.
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
      Exceptions().throwErrorCreatingFolder(folderName);
      return;
    }
  }

  /// The function `_createFile` creates a new file with the given `fileName` and optionally writes the provided `content` to it.
  ///
  /// Args:
  ///   `fileName` (String): The name of the file to be created.
  ///   `content` (String, optional): The content to be written to the file. Default value is an empty string.
  ///
  /// This function first creates a `File` object with the given `fileName`. Then, it tries to create the file synchronously.
  /// If an error occurs during the file creation, it calls the `throwErrorCreatingFile` method from an instance of the `Exceptions` class, passing the `fileName` as an argument.
  /// This method throws a `GenesisCreateException` with a custom message. After throwing the exception, the function returns.
  /// If `content` is not an empty string, it tries to write the `content` to the file synchronously.
  /// If an error occurs during the writing process, it writes an error message to the standard output and returns.
  void _createFile(String fileName, {String content = ''}) {
    File file = File(fileName);
    try {
      file.createSync();
    } catch (e) {
      Exceptions().throwErrorCreatingFile(fileName);
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

  /// The function `_createModel` creates a new Dart file with the given `modelFileName` and writes a model class to it.
  ///
  /// Args:
  ///   `modelFileName` (String): The name of the file to be created.
  ///   `properties` (Map<String, String>): The properties of the model. Each key-value pair represents a property name and its type.
  ///   `database` (bool): A flag indicating whether to generate database methods for the model.
  ///
  /// This function first extracts the model name from the `modelFileName`. Then, it calls the `_createFile` function to create a new Dart file with the `modelFileName` and writes a model class to it.
  /// The model class extends the `Dao` class and includes constructors, property definitions, JSON serialization methods, and database methods generated by the `GenerateModel` class based on the `properties` and `database` arguments.
  /// It also includes predefined fields, getters, and operator overloads.
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

  /// The function `createReflectionNeeds` creates two files, `lib/builder.dart` and `build.yaml`, which are necessary for the reflectable package to generate reflection data.
  ///
  /// This function first defines the routes and contents of the `lib/builder.dart` and `build.yaml` files.
  /// The `lib/builder.dart` file includes an import statement for the `reflectable_builder` package and a `main` function that calls the `reflectableBuild` function from the package.
  /// The `build.yaml` file includes a configuration for the reflectable builder to generate reflection data for Dart files in the `lib/database/entity` directory.
  /// Then, it creates `File` objects with the defined routes and writes the defined contents to the files synchronously.s
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

  // void _createStateLessWidget(String stateLessWidgetName) {}

  // void _createStateFullWidget(String stateFullWidgetName) {}
}
