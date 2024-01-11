import 'package:genesis/src/features/error_control/gaenesis_list_exception.dart';
import 'package:genesis/src/features/error_control/genesis_preferences_exception.dart';

class Exceptions {
  final String _preferencesNoneValue =
      'The key +++ is not defined as User Preferences variable. Use `Preferences.userPreferences.addAll({\'+++\': <default value>});` to set the variable on preferences';
  final String _badPreferencesType =
      'The type +++ cannot be settled or gotten from preferences.';
  final String _noElements = 'The list is empty';
  final String _methodNotAvailableForLists =
      'This method is not available for lists';

  String _generateException(String value, String variable) {
    return value.replaceAll('+++', variable);
  }

  void throwPreferencesNoneValue(dynamic key) {
    throw GenesisPreferencesException(
        _generateException(_preferencesNoneValue, '$key'));
  }

  void throwBadPreferencesType(dynamic key) {
    throw GenesisPreferencesException(
        _generateException(_badPreferencesType, '${key.runtimeType}'));
  }

  void throwNoElements() {
    throw GenesisPreferencesException(_noElements);
  }

  void throwMethodNotAvailableForLists() {
    throw GenesisListException(_methodNotAvailableForLists);
  }
}
