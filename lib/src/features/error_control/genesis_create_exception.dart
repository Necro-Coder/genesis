import 'package:genesis/src/features/error_control/genesis_exception.dart';

/// The GenesisCreateException class is a subclass of GenesisException.
class GenesisCreateException extends GenesisException {
  /// The code `GenesisCreateException(super.message, {super.stackTrace = ''})` is defining a
  /// constructor for the `GenesisCreateException` class.
  GenesisCreateException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisCreateException: ';
  }
}
