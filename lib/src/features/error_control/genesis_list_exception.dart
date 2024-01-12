import 'package:genesis/src/features/error_control/genesis_exception.dart';

/// The GenesisListException class is a custom exception that extends the GenesisException class.
class GenesisListException extends GenesisException {
  /// The code `GenesisListException(super.message, {super.stackTrace = ''})` is defining a constructor
  /// for the `GenesisListException` class.
  GenesisListException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisListException: ';
  }
}
