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
