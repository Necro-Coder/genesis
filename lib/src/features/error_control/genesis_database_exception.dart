import 'package:genesis/src/features/error_control/genesis_exception.dart';

class GenesisDatabaseException extends GenesisException {
  GenesisDatabaseException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisDatabaseException: ';
  }
}
