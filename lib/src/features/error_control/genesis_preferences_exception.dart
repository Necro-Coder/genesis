import 'package:genesis/src/features/error_control/genesis_exception.dart';

/// The GenesisPreferencesException class is a subclass of GenesisException.
class GenesisPreferencesException extends GenesisException {
  /// The code is defining a constructor for the `GenesisPreferencesException` class.
  GenesisPreferencesException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisPreferenceException: ';
  }
}
