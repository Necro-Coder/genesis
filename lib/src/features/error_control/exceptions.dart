import 'package:genesis/src/features/error_control/error_control.dart';
import 'package:genesis/src/features/error_control/genesis_create_exception.dart';

/// The Exceptions class is used to handle and manage exceptions in Genesis framework.
class Exceptions {
  final String _preferencesNoneValue =
      'The key +++ is not defined as User Preferences variable. Use `Preferences.userPreferences.addAll({\'+++\': <default value>});` to set the variable on preferences';
  final String _badPreferencesType =
      'The type +++ cannot be settled or gotten from preferences.';
  final String _noPreferencesElement =
      'The model +++ is empty on preferences. Cannot get the value.';
  final String _noElements = 'The list is empty';
  final String _methodNotAvailableForLists =
      'This method is not available for lists';
  final String _notGBaseModel = 'The model is not a GBaseModel';
  final String _errorCreatingGenesisFile = 'Error creating +++';
  final String _errorReadingGenesisFile = 'Error reading +++';
  final String _errorCreatingFolder =
      'An error occurred while creating the folder `+++`';
  final String _errorCreatingFile =
      'An error occurred while creating the file `+++`';
  final String _errorEmptyMetadata =
      'The metadata file is empty, please, execute genesis create with the genesis.gs complete.';

  final String _errorModelNoName = 'At least one model does not have a name';
  final String _errorScreenNoName = 'At least one screen does not have a name';
  final String _errorFolderNoName = 'At least one screen does not have a name';
  final String _errorWidgetNoName = 'At least one screen does not have a name';
  final String _errorPropertyNoName =
      'At least one property does not have a name';

  final String _errorNoTableForeign = 'The property +++ does not have a table';
  final String _noStateTemplate =
      'The screen +++ does not have a state or template';
  final String _tabErrorOnFile = 'The tabulation cannot be 0 on files';
  final String _errorNeedUpperFolder =
      'The folder/file +++ needs an folder container';
  final String _errorNoType = 'The type +++ is not available';

  /// The function replaces all occurrences of `+++` in a string with a given variable.
  ///
  /// Args:
  ///   `value` (String): The value parameter is a string that represents the original value where we want
  /// to replace a specific pattern with the variable parameter.
  ///   variable (String): The variable parameter is a string that represents the name of a variable.
  ///
  /// Returns:
  ///   The method is returning a string after replacing all occurrences of the string `+++` with the
  /// value of the variable.
  String _generateException(String value, String variable) {
    return value.replaceAll('+++', variable);
  }

  /// The function throws a GenesisPreferencesException with a generated exception message.
  ///
  /// Args:
  ///   `key` (dynamic): The key parameter is a dynamic type, which means it can accept any type of value.
  /// It is used as a parameter to generate an exception message.
  void throwPreferencesNoneValue(dynamic key) {
    throw GenesisPreferencesException(
        _generateException(_preferencesNoneValue, '$key'));
  }

  /// The function throws a GenesisPreferencesException with a generated exception message.
  ///
  /// Args:
  ///   `key` (dynamic): The parameter "key" is of type "dynamic", which means it can accept any type of
  /// value.
  void throwBadPreferencesType(dynamic key) {
    throw GenesisPreferencesException(
        _generateException(_badPreferencesType, '${key.runtimeType}'));
  }

  /// The function throws a GenesisPreferencesException with a message indicating that there are no
  /// elements.
  void throwNoElements() {
    throw GenesisPreferencesException(_noElements);
  }

  /// The function throws a GenesisListException with a message indicating that the method is not
  /// available for lists.
  void throwMethodNotAvailableForLists() {
    throw GenesisListException(_methodNotAvailableForLists);
  }

  /// The function throws a GenesisDatabaseException with a message indicating that the object is not a
  /// GBaseModel.
  void throwNotGBaseModel() {
    throw GenesisDatabaseException(_notGBaseModel);
  }

  /// The function throws a GenesisPreferencesException with a generated exception message.
  ///
  /// Args:
  ///   `model` (dynamic): The `model` parameter is a dynamic variable that represents the data model
  /// being used in the code.
  void throwNoPreferencesElement(dynamic model) {
    throw GenesisPreferencesException(
        _generateException(_noPreferencesElement, '$model'));
  }

  /// The `throwErrorCreatingGenesisFile` function throws a `GenesisCreateException` with a specific error message and stack trace.
  ///
  /// Args:
  ///   `file` (String): The name of the file where the error occurred.
  ///   `error` (dynamic): The error that occurred.
  ///
  /// This function generates an error message using the `_generateException` function with the `_errorCreatingGenesisFile` string and the `file` name.
  /// Then, it throws a `GenesisCreateException` with the generated error message and the `error` stack trace.
  void throwErrorCreatingGenesisFile(String file, dynamic error) {
    throw GenesisCreateException(
        _generateException(_errorCreatingGenesisFile, file),
        stackTrace: error);
  }

  /// The `throwErrorReadingGenesisFile` function throws a `GenesisCreateException` with a message indicating that there was an error reading a Genesis file.
  ///
  /// Args:
  ///   `file` (String): The name of the file where the error occurred.
  ///   `error` (dynamic): The error that occurred.
  ///
  /// This function generates an error message using the `_generateException` function with the `_errorReadingGenesisFile` string and the `file` name.
  /// Then, it throws a `GenesisCreateException` with the generated error message and the `error` stack trace.
  void throwErrorReadingGenesisFile(String file, dynamic error) {
    throw GenesisCreateException(
        _generateException(_errorReadingGenesisFile, file),
        stackTrace: error);
  }

  /// The function `throwErrorCreatingFolder` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  ///   `folder` (String): The name of the folder that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_errorCreatingFolder` and `folder` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorCreatingFolder(String folder) {
    throw GenesisCreateException(
        _generateException(_errorCreatingFolder, folder));
  }

  /// The function `throwErrorCreatingFile` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  ///   `file` (String): The name of the file that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_errorCreatingFile` and `file` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorCreatingFile(String file) {
    throw GenesisCreateException(_generateException(_errorCreatingFile, file));
  }

  /// The function `throwErrorEmptyMetadata` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorEmptyMetadata` message.
  void throwErrorEmptyMetadata() {
    throw GenesisCreateException(_errorEmptyMetadata);
  }

  /// The function `throwErrorModelNoName` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorModelNoName` message.
  void throwErrorModelNoName() {
    throw GenesisCreateException(_errorModelNoName);
  }

  /// The function `throwErrorPropertyNoName` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorPropertyNoName` message.
  void throwErrorPropertyNoName() {
    throw GenesisCreateException(_errorPropertyNoName);
  }

  /// The function `throwErrorNoTableForeign` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  ///  `property` (String): The name of the property that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_errorNoTableForeign` and `property` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorNoTableForeign(String property) {
    throw GenesisCreateException(
        _generateException(_errorNoTableForeign, property));
  }

  /// The function `throwErrorScreenNoName` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorScreenNoName` message.
  void throwErrorScreenNoName() {
    throw GenesisCreateException(_errorScreenNoName);
  }

  /// The function `throwErrorFolderNoName` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorFolderNoName` message.
  void throwErrorFolderNoName() {
    throw GenesisCreateException(_errorFolderNoName);
  }

  /// The function `throwErrorWidgetNoName` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_errorWidgetNoName` message.
  void throwErrorWidgetNoName() {
    throw GenesisCreateException(_errorWidgetNoName);
  }

  /// The function `throwErrorNoStateTemplate` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  /// `screen` (String): The name of the screen that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_noStateTemplate` and `screen` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorNoStateTemplate(String screen) {
    throw GenesisCreateException(_generateException(_noStateTemplate, screen));
  }

  /// The function `throwTabErrorOnFile` throws a `GenesisCreateException` with a custom message.
  ///
  /// This function throws a `GenesisCreateException` with the `_tabErrorOnFile` message.
  void throwTabErrorOnFile() {
    throw GenesisCreateException(_tabErrorOnFile);
  }

  /// The function `throwErrorNeedUpperFolder` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  /// `folder` (String): The name of the folder that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_errorNeedUpperFolder` and `folder` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorNeedUpperFolder(String folder) {
    throw GenesisCreateException(
        _generateException(_errorNeedUpperFolder, folder));
  }

  /// The function `throwErrorNoType` throws a `GenesisCreateException` with a custom message.
  ///
  /// Args:
  /// `type` (String): The name of the type that caused the error. It is used to generate the exception message.
  ///
  /// This function calls the `_generateException` method with `_errorNoType` and `type` as arguments to generate a custom exception message.
  /// Then, it throws a `GenesisCreateException` with the generated message.
  void throwErrorNoType(String type) {
    throw GenesisCreateException(_generateException(_errorNoType, type));
  }
}
