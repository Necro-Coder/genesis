import 'dart:io';

import 'package:genesis/src/features/commands/create/create.dart';
import 'package:genesis/src/features/commands/init.dart';
import 'package:genesis/src/features/commands/help.dart';
import 'package:genesis/src/features/error_control/genesis_exception.dart';

void main(List<dynamic> arguments) async {
  bool isRoot = false;
  var dir = Directory.current;
  var file = File('${dir.path}/pubspec.yaml');

  if (file.existsSync()) {
    isRoot = true;
  }

  if (arguments.isEmpty) {
    Help().printHelp('all');
    return;
  } else if (!isRoot) {
    throw GenesisException(
        '\nYou are not in the root of the project, please, move to the root of the project to avoid fails\n');
  }

  switch (arguments[0]) {
    case 'help':
      Help().printHelp(arguments.length < 2 ? '' : arguments[1]);
      break;
    case 'init':
      Init().init();
      break;
    case 'create':
      List<String> commandArguments = [];
      for (var i = 1; i < arguments.length; i++) {
        commandArguments.add(arguments[i]);
      }
      await Create().create(commandArguments);
      if (commandArguments.contains('model') || commandArguments.isEmpty) {
        Create().createReflectionNeeds();
        try {
          await Process.start('dart lib/builder.dart lib/main.dart', []);
        } catch (e) {
          throw GenesisException(e.toString());
        }
      }
      break;
    case 'delete':
      break;
    case 'preferences':
      break;
    case 'database':
      break;
    default:
      Help().printHelp('');
  }
}
