import 'package:genesis/src/features/error_control/genesis_exception.dart';

/// The GenesisDatabaseException class is a subclass of GenesisException.
class GenesisDatabaseException extends GenesisException {
  /// The code `GenesisDatabaseException(super.message, {super.stackTrace = ''})` is defining a
  /// constructor for the `GenesisDatabaseException` class.
  GenesisDatabaseException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisDatabaseException: ';
  }
}
