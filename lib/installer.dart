import 'dart:io';

void main() async {
  String path = await createGenesisCommandScript();
  if (path == '-1') {
    print('Error al crear el comando');
  }
}

Future<String> createGenesisCommandScript() async {
  try {
    // Contenido del archivo genesis_command.dart
    var scriptContent = '''
import 'dart:io';

import 'package:genesis/genesis.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stdout.writeln('Use: dart run genesis.dart <command>');
    return;
  }

  var command = args[0];

  switch (command) {
    case 'init':
      Init();
      break;
    case 'create':
      Create(args.length < 2 ? '' : args[1]);
      break;
    case 'make':
      Make(args.length < 2 ? '' : args[1]);
      break;
    case 'analyze':
      Analyze();
      break;
    default:
      stdout.writeln('Comando no reconocido');
  }
}
''';

    // Guardar el contenido en un archivo llamado genesis_command.dart
    var scriptFile = File('genesis.dart');
    await scriptFile.writeAsString(scriptContent);
    return scriptFile.absolute.path;
  } catch (e) {
    return '-1';
  }
}
