import 'dart:io';

import 'package:genesis/code_generation/code_generator.dart';
import 'package:process_run/process_run.dart';

class Make extends CodeGenerator {
  Make(String args) {
    switch (args) {
      case 'models':
        createModels();
        break;
      case 'preferences':
        createPreferences();
        break;
      default:
        createModels();
        createPreferences();
        break;
    }

    stdout.writeln('Finising generation process.');
    executeCommand();
  }

  void createPreferences() {
    String preferencesContent = readPreferencesFile();

    String preferencesStructure = parsePreferencesContent(preferencesContent);

    appendToPreferencesFile(preferencesStructure);
  }

  void createModels() {
    String baseDirectory = 'lib/backend/database/models';

    List<String> folders = getFoldersName(baseDirectory);

    for (var folder in folders) {
      stdout.writeln(folder);
      folderProcess(baseDirectory, folder);
    }
  }

  String readPreferencesFile() {
    try {
      File preferencesFile = File('lib/genesis/preferences.gs');
      return preferencesFile.readAsStringSync();
    } catch (e) {
      stdout.writeln('Error reading preferences.gs file: $e');
      return '';
    }
  }

  String parsePreferencesContent(String content) {
    // Split content by ', ' and create structure
    List<String> preferencesList = content.split(', ');
    String structure = '';

    for (String preference in preferencesList) {
      List<String> parts = preference.split(':');
      if (parts.length == 2) {
        String key = parts[0].trim();
        String type = parts[1].trim();

        // Create structure for the preference
        structure += createPreferenceStructure(key, type);
      }
    }

    return structure;
  }

  String createPreferenceStructure(String key, String type) {
    //TODO: Hacer la parte de la serialización.
    String capitalizedType = type == 'string' ? capitalize(type) : type;
    String defaultValue = getDefaultValue(type);

    return '''
  static $capitalizedType? _${key.toLowerCase()} = $defaultValue;
  static $capitalizedType? get $key => _prefs.get${capitalize(type)}('$key') ?? _$key;
  static set $key($capitalizedType? value) {
    _${key.toLowerCase()} = value;
    _prefs.set${capitalize(type)}('$key', _${key.toLowerCase()}!);
  }
  ''';
  }

  String capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  String getDefaultValue(String type) {
    // Provide default values based on the type
    switch (type) {
      case 'String':
        return "''";
      case 'int':
        return '0';
      case 'double':
        return '0.0';
      case 'bool':
        return 'false';
      default:
        return "''";
    }
  }

  void appendToPreferencesFile(String structure) {
    try {
      File preferencesFile =
          File('lib/backend/shared_preferences/preferences.dart');

      // Read existing content
      String existingContent = preferencesFile.readAsStringSync();

      // Remove the last line (closing bracket) if it exists
      int lastBracketIndex = existingContent.lastIndexOf('}');
      if (lastBracketIndex != -1) {
        existingContent = existingContent.substring(0, lastBracketIndex);
      }
      String updatedContent = '$existingContent\n}';
      stdout.writeln(structure);
      if(!existingContent.contains(structure)) updatedContent = '$existingContent$structure\n}';

      // Write back to preferences.dart
      preferencesFile.writeAsStringSync(updatedContent);

      stdout.writeln('Preferences updated successfully!');
    } catch (e) {
      stdout.writeln(('Error updating preferences file: $e'));
    }
  }

  void folderProcess(String baseDirectory, String folder) {
    String fullPath = '$baseDirectory/$folder';
    String inFile = '$fullPath/$folder.gs';
    String outFile = '$fullPath/$folder.dart';

    try {
      List<String> lines = File(inFile).readAsLinesSync();

      String outContent = modelContentGeneration(lines, folder);

      File(outFile).writeAsStringSync(outContent);

      stdout.writeln('File Generated: $outFile');
    } catch (e) {
      stdout.writeln('Error while processing folder $folder: $e}');
    }
  }

  String modelContentGeneration(List<String> lines, String fileName) {
    List<String> parts = lines[0].split(", ");

    String model = fileName.replaceFirst(
        fileName.substring(0, 1), fileName.substring(0, 1).toUpperCase());
    List<String> names = [for (var part in parts) part.split(':')[0]];
    List<String> types = [for (var part in parts) part.split(':')[1]];

    String content = '''
import 'dart:convert';

import 'package:sqflite_simple_dao_backend/database/database/Reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

/* Important to use the sqflite_simple_dao_backend to import the @reflector */
@reflector
class $model{
  /* Variables we have in the model */
  ${generateVariableDeclaration(names, types)}

  /* Empty constructor */
  $model();

  /* Named constructor with all the fields and named '.all()' */
  $model.all({${constructorGeneration(names)}});

  /* A map that contains the name of the fields and the database types. */
  static final Map<String, String> _fields = {
  ${fieldsMapGeneration(names, types)}
  };

  /* This factory to create objects from json */
  factory $model.fromRawJson(String str) =>
      $model.fromJson(json.decode(str));

  /* The fromJson */
  factory $model.fromJson(Map<String, dynamic> json) => $model.all(
  ${fromJsonGeneration(names)}
  );

  /* The toJson */
  Map<String, dynamic> toJson() => {
  ${toJsonGeneration(names)}
  };

  /* An iterable object with all the keys in the fields map. */
  static final Iterable<String> _names = _fields.keys;

  /* A list with the primary key values */
  static final List<String> _primary = [];
  
  /* A exception list in order to remove some elements from the iteration */
  static final List<String> _exception = [];

  /* A list with the complete line (string) of a foreing key. Example behind.*/
  static final List<String> _foreign = [];
  /* Example: 'FOREIGN KEY (model_id) REFERENCES model (id)' */

  /* Getters and Setters*/
  static List<String> get foreign => _foreign;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get primary => _primary;

  static List<String> get exception => _exception;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is $model &&
        ${objectEqualsGenerator(names)}
  }

  @override
  int get hashCode {
    ${hasCodeGenerator(names)}
  }
}
''';

    return content;
  }

  String fieldsMapGeneration(List<String> names, List<String> types) {
    Map<String, String> avalibleTypes = {
      'int': 'Constants.integer',
      'text': 'Constants.text',
      'bool': 'Constants.boolean',
      'date': 'Constants.datetime',
      'bigint': 'Constants.bigint',
      'varchar': 'Constants.varchar',
      'decimal': 'Constants.decimal',
    };

    return names.map((field) {
      final type = types[names.indexOf(field)];
      final avalible = avalibleTypes[type.split('-')[0]];

      if (avalible != null) {
        return '\n"$field" : ${avalible.contains('varchar') || avalible.contains('decimal') ? '${avalibleTypes[type.split('-')[0]]}["${type.split('-')[1]}"]!' : avalible},';
      } else {
        return '';
      }
    }).join('\n');
  }

  String fromJsonGeneration(List<String> names) {
    return names.map((field) => '\t$field : json["$field"],').join('\n');
  }

  String toJsonGeneration(List<String> names) {
    return names.map((field) => '\t"$field" : $field,').join('\n');
  }

  String constructorGeneration(List<String> names) {
    return names.map((field) => 'this.$field,').join();
  }

  String objectEqualsGenerator(List<String> names) {
    return names
        .map((field) => field != names.last
            ? 'other.$field == $field &&'
            : 'other.$field == $field;')
        .join('\n');
  }

  String hasCodeGenerator(List<String> names) {
    return names
        .map((field) => field != names.last
            ? field != names.first
                ? '$field.hashCode ^'
                : 'return $field.hashCode ^'
            : '$field.hashCode;')
        .join('\n');
  }

  String generateVariableDeclaration(
      List<String> fieldsNames, List<String> fieldsTypes) {
    Map<String, String> avalibleTypes = {
      'int': 'int',
      'text': 'String',
      'bool': 'bool',
      'date': 'DateTime',
      'bigint': 'int',
      'varchar': 'String',
      'decimal': 'double',
    };
    return fieldsNames
        .map((campo) =>
            '  ${avalibleTypes[fieldsTypes[fieldsNames.indexOf(campo)].split('-')[0]]}? $campo;')
        .join('\n');
  }

  List<String> getFoldersName(String directory) {
    Directory dir = Directory(directory);

    List<String> gsFileNames = [];

    dir.listSync().whereType<Directory>().forEach((dir) {
      var gsFiles = dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.gs'))
          .toList();

      if (gsFiles.isNotEmpty) {
        String gsName = gsFiles.first.uri.pathSegments.last;

        gsFileNames.add(gsName.substring(0, gsName.length - 3));
      }
    });

    return gsFileNames;
  }

  Future<void> executeCommand() async {
    final platform = Platform.operatingSystem;

    switch (platform) {
      case 'windows':
        await commandExecuter('dart lib/builder.dart lib/main.dart');
        break;
      case 'macos':
      case 'linux':
        await commandExecuter('dart lib/builder.dart lib/main.dart');
        break;
      default:
        stdout.writeln('Plataforma no soportada: $platform');
    }
  }

  Future<void> commandExecuter(String comando) async {
    stdout.writeln('Ejecutando comando: $comando');
    final shellRunner = Shell();
    await shellRunner.run(comando);
  }
}
