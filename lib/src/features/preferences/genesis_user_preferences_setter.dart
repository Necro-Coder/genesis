import 'package:genesis/src/features/preferences/genesis_preferences_manager.dart';

/// `GenesisUserPreferencesSetter` is a class that sets the user preferences values
/// in the `GenesisPreferencesManager` class.
///
class GenesisUserPreferencesSetter {
  GenesisUserPreferencesSetter(userPreferences) {
    GenesisPreferencesManager.userPreferences = userPreferences;
  }
}
