import 'package:genesis/src/features/commands/create/create.dart';
import 'package:genesis/src/features/commands/init.dart';
import 'package:genesis/src/features/commands/help.dart';

void main(List<dynamic> arguments) {
  if (arguments.isEmpty) {
    Help().printHelp('all');
    return;
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
      Create().create(commandArguments);
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
