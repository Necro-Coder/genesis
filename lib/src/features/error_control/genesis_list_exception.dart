import 'package:genesis/src/features/error_control/genesis_exception.dart';

class GenesisListException extends GenesisException {
  GenesisListException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisListException: ';
  }
}
