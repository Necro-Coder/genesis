import 'dart:io';

import 'package:genesis/src/features/commands/create/generate_model.dart';
import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/features/error_control/genesis_create_exception.dart';
import 'package:genesis/src/features/writer/genesis_files/genesis_metadata_writer_new.dart';
import 'package:genesis/src/helpers/console_color.dart';

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
  Future<void> create(List<String> arguments) async {
    if (arguments.isEmpty) {
      File genesisFile = File('$_genesisFolderPath/genesis.gs');
      if (!genesisFile.existsSync()) {
        Exceptions().throwGenesisFileNotExist();
        return;
      }
      stdout
          .write(ConsoleColor.penInfo('Reading the asdf genesis.gs file...\n'));
      stdout.write(ConsoleColor.penSuccess('genesis.gs read successfully\n'));
      stdout.write(
          ConsoleColor.penInfo('Writing the genesis.gs.metadata file...\n'));
      try {
        await MetadataManager().manageMetadata();
      } catch (e) {
        throw GenesisCreateException(e.toString());
      }
      stdout.write(ConsoleColor.penSuccess(
          'genesis.gs.metadata written successfully\n'));
      stdout.write(ConsoleColor.penInfo('Creating the project structure...\n'));
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
      if (!file.existsSync()) {
        file.createSync();
      }
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
  void _createModel(String modelFileName, Map<String, String> properties) {
    String modelName = modelFileName.split('/').last.split('.').first;
    _createFile(modelFileName, content: '''
import 'dart:convert';

@reflector
class $modelName extends Dao {
  $modelName();

  $modelName.all({${GenerateModel().generateModelConstructor(properties)}});

  ${GenerateModel().generateModelProperties(properties)}

  factory $modelName.fromRawMap(String str) => $modelName.fromMap(json.decode(str));
  
  /// The function is an override method that converts a map to a GenesisSerializableObject.
  ///
  /// Args:
  ///   map (Map<String, dynamic>): A map containing key-value pairs where the keys are strings and the
  /// values can be of any type.
  ///
  /// Returns:
  ///   The method is returning the result of calling the `fromMap` method of the superclass.
  @override
  factory $modelName.fromMap(Map<String, dynamic> json) => $modelName.all(
        ${GenerateModel().generateFromJson(properties)}
  );

  /// The function `toMap()` returns a map representation of the object.
  ///
  /// Returns:
  ///   The method is returning the result of calling the `toMap()` method on the superclass.
  @override
  Map<String, dynamic> toMap() => {
        ${GenerateModel().generateToJson(properties)}
  };
  ${GenerateModel().generateDatabaseMethods(properties)}

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
    String buildYamlContent = '''
targets:
  \$default:
    builders:
      reflectable:
        generate_for:
          - /**.dart //TODO: Get the models directory from the genesis.gs file
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
