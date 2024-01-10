import 'package:genesis/src/features/error_control/genesis_exception.dart';

class GenesisCreateException extends GenesisException {
  GenesisCreateException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisCreateException: ';
  }
}
