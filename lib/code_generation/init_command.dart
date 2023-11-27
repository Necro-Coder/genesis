import 'dart:io';

import 'package:genesis/code_generation/code_generator.dart';

class Init extends CodeGenerator {
  Init() {
    String genericComment = '// Do not touch this file';
    String baseDir = 'lib';

    mainStructure();

    /* region: Build.yaml creation */
    createBuild();

    /* region: Backend creation */
    backendCreation(baseDir, genericComment);

    /* region: Frontend creation */
    frontendCreation(baseDir, genericComment);

    /* region: Genesis creation */
    genesisCreation(baseDir);
  }

  void genesisCreation(String baseDir) {
    baseDir = '$baseDir/genesis';
    createFiles({
      '$baseDir/models.gs':
          '/** Write the name of the models separated by commas. Ex: Item, Supplier, User, etc. Remember to put space after the comma. (Delete this line.) */ ',
      '$baseDir/screens.gs':
          '/** Write the name of the screens separated by commas. Ex: home_screen, config_screen, etc. Remember to put space after the comma and respect the snake_case. (Delete this line.) */ ',
      '$baseDir/providers.gs':
          '/** Write the name of the providers separated by commas. Ex: login_provider, list_provider, etc. Remember to put space after the comma and respect the snake_case. (Delete this line.) */ ',
      '$baseDir/preferences.gs':
          '/** Write the name of the attributes, followed by a colon and the data type separated by commas. Ex: host:string, port:int, path:string. Remember to separate by commas and put a space after the comma, also the objects that can be saved in preference must be serialized. (Delete this line.) */ ',
      '$baseDir/components.gs':
          '/** TODO */ '
    });
  }

  void frontendCreation(String baseDir, String genericComment) {
    baseDir = '$baseDir/frontend';
    createFiles({
      '$baseDir/screens/screens.dart': genericComment,
      '$baseDir/components/components.dart': genericComment
    });
  }

  void backendCreation(String baseDir, String genericComment) {
    baseDir = '$baseDir/backend';
    createDirectories([
      '$baseDir/database',
      '$baseDir/providers',
      '$baseDir/shared_preferences',
    ]);

    createFiles({
      '$baseDir/database/config.dart': genericComment,
      '$baseDir/database/models/models.dart': genericComment,
      '$baseDir/shared_preferences/preferences.dart': '''
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  
   static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }
}
      ''',
      '$baseDir/providers/providers.dart': genericComment
    });
  }

  createBuild() {
    createFileWithComment('build.yaml', '''
targets: 
  \$default:
    builders:
      reflectable:
        generate_for:
          - lib/database/models/**.dart
        options:
          formatted: true
    ''');

    createFileWithComment('lib/builder.dart', '''
import 'package:reflectable/reflectable_builder.dart' as builder;

main(List<String> arguments) async {
  await builder.reflectableBuild(arguments);
}
    ''');
  }

  mainStructure() async{
    try {
      // Specify the path to your main.dart file
      String mainFilePath = 'lib/main.dart';

      // Read the existing content of main.dart
      File mainFile = File(mainFilePath);
      String content = await mainFile.readAsString();

      // Check if the imports and lines already exist
      if (!content.contains("import 'main.reflectable.dart';")) {
        // Insert the required imports and lines at the beginning of the file
        content = "import 'package:reflectable/reflectable.dart'\n\nimport 'package:flutter/services.dart';\n\nimport 'main.reflectable.dart';\nimport './backend/shared_preferences/preferences.dart';\n\n$content";
      }

      if (!content.contains("initializeReflectable();")) {
        // Insert the required lines inside the main function
        content = content.replaceFirst(
          'void main() {',
          'void main() async {\n  initializeReflectable();\n  WidgetsFlutterBinding.ensureInitialized();\n  await Preferences.init();\n',
        );
      }

      // Write the modified content back to main.dart
      await mainFile.writeAsString(content);

      stdout.writeln('Initialization code injected successfully!');
    } catch (e) {
      stdout.writeln('Error injecting initialization code: $e');
    }
  }
}
