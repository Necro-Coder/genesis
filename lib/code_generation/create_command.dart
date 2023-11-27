import 'dart:io';

import 'package:genesis/code_generation/code_generator.dart';

class Create extends CodeGenerator {
  Create(String arg) {
    switch (arg) {
      case 'models':
        createModels();
        break;
      case 'screens':
        createRouter();
        createScreens();
        break;
      case 'providers':
        createProviders();
        break;
      default:
        createModels();
        createProviders();
        createScreens();
        break;
    }
  }

  void createProviders() {
    List<String> providers = getFileLines('lib/genesis/providers.gs');
    createFieldsFolders('lib/backend/providers', providers);
  }

  void createScreens() {
    List<String> screens = getFileLines('lib/genesis/screens.gs');
    createScreenFiles('lib/frontend/screens', screens);
  }

  void createModels() {
    List<String> models = getFileLines('lib/genesis/models.gs');
    createFieldsFolders('lib/backend/database/models', models);
  }

  void createRouter() {
    createFileWithComment('lib/frontend/router/router.dart', '''
import 'package:flutter/material.dart';
import '../screens/screens.dart';

class RoutesList {
  static String initialRoute = '';

  static final menuOptions = <MenuOption>[
  // menuOption instance
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final e in menuOptions) {
      appRoutes.addAll({e.route: (BuildContext context) => e.screen});
    }

    return appRoutes;
  }

  static Route<dynamic>? onGeneratedRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => menuOptions[0].screen);
  }
}

class MenuOption {
  final String route;
  final String name;
  final Widget screen;

  MenuOption(
      {required this.route,
        required this.name,
        required this.screen});
}
    ''');
  }

  void insertCodeInRoutesList(List<String> menuOptionsCode) {
    const String routesListFilePath = 'lib/frontend/router/router.dart';

    if (File(routesListFilePath).existsSync()) {
      String routesListContent = File(routesListFilePath).readAsStringSync();

      final insertIndex = routesListContent.indexOf('// menuOption instance');
      if (insertIndex != -1) {
        final newContent = routesListContent.replaceRange(
          insertIndex,
          insertIndex + '// menuOption instance'.length,
          menuOptionsCode.join(',\n'),
        );

        File(routesListFilePath).writeAsStringSync(newContent);
      }
    } else {
      print('Error: No se encontró el archivo RoutesList');
    }
  }

  static List<String> getFileLines(String filePath) {
    try {
      File file = File(filePath);
      List<String> lines = file.readAsLinesSync();
      return lines[0].split(", ");
    } catch (e) {
      stdout.writeln('Error while reading file: $e');
      return [];
    }
  }

  static List<String> getFieldsName(String directory) {
    Directory dir = Directory(directory);
    return dir
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .toList();
  }

  void createFieldsFolders(String destDirectory, List<String> fieldsNames) {
    for (var name in fieldsNames) {
      String folderPath = '$destDirectory/$name';
      String filePath = '$folderPath/$name.gs';

      createDirectory(folderPath);
      createFileWithComment(filePath,
          '/* Write the name of the attributes, followed by a colon and the data type separated by commas. Ex: host:string, port:int, path:string. Remember to separate by commas and put a space after the comma. (Delete this file) */');
    }
  }

  void createScreenFiles(String destDirectory, List<String> names) {
    String screensFilePath = '$destDirectory/screens.dart';
    File(screensFilePath).writeAsStringSync('', mode: FileMode.write);

    for (var name in names) {
      String relativePath = './$name.dart';
      String exportStatement = "export '$relativePath';\n";

      String filePath = '$destDirectory/$name.dart';

      // Verificar si el archivo ya existe antes de crearlo
      if (!File(filePath).existsSync()) {
        File(filePath).writeAsStringSync(createScreenCode(name));
      } else {
        stdout.writeln('$name already exists, it wont be created again.');
      }
      insertExportStatement(screensFilePath, exportStatement);
      insertCodeInRoutesList([
        '''
// menuOption instance 
MenuOption(
  name: ${toCamelCase(name)}.routeName,
  screen: const ${toCamelCase(name)}(),
  route: ${toCamelCase(name)}.routeName),
      '''
      ]);
    }
  }

  String createScreenCode(String name) {
    String camelCaseName = toCamelCase(name);
    String variableRouteName = '_${name.toLowerCase()}';

    return '''
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class $camelCaseName extends StatefulWidget {
  static const String routeName = '$variableRouteName';
  const $camelCaseName({super.key});

  @override
  State<$camelCaseName> createState() => _${camelCaseName}State();
}

class _${camelCaseName}State extends State<$camelCaseName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$camelCaseName'),
      ),
      body: ScreenTypeLayout.builder(
        mobile: (context) => Container(color:Colors.blue),
        tablet: (context) => Container(color: Colors.yellow),
        desktop: (context) => Container(color: Colors.red),
        watch: (context) => Container(color: Colors.purple),
      ),
    );
  }
}
''';
  }

  void insertExportStatement(String filePath, String exportStatement) {
    File(filePath).writeAsStringSync(exportStatement, mode: FileMode.append);
  }
}
