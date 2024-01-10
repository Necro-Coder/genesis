import 'package:genesis/src/features/error_control/genesis_exception.dart';

class GenesisPreferencesException extends GenesisException {
  GenesisPreferencesException(super.message, {super.stackTrace = ''}) {
    super.exceptionMessage = 'GenesisPreferenceException: ';
  }
}
