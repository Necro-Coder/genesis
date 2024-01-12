/// The GenesisException class is a custom exception class in Dart.
class GenesisException implements Exception {
  /// The line `final String message;` is declaring a final instance variable `message` of type `String`
  /// in the `GenesisException` class. This variable will hold the message associated with the
  /// exception.
  final String message;

  /// The line `final String stackTrace;` is declaring a final instance variable `stackTrace` of type
  /// `String` in the `GenesisException` class. This variable will hold the stack trace associated with
  /// the exception. The stack trace is a record of the active stack frames at a certain point in time
  /// during the execution of a program. It provides information about the sequence of function calls
  /// that led to the current point of execution.
  final String stackTrace;

  /// The line `String exceptionMessage = '';` is declaring a variable `exceptionMessage` of type
  /// `String` and initializing it with an empty string. This variable is an instance variable of the
  /// `GenesisException` class. It is used to store an additional message that can be set or retrieved
  /// using the getter and setter methods `getExceptionMessage` and `setExceptionMessage`.
  String exceptionMessage = '';

  get getExceptionMessage => exceptionMessage;

  set setExceptionMessage(final exceptionMessage) =>
      this.exceptionMessage = exceptionMessage;

  GenesisException(this.message, {this.stackTrace = ''});

  /// The function returns a formatted string representation of an exception message, stack trace, and
  /// additional information.
  ///
  /// Returns:
  ///   The method is returning a formatted string that includes an exception message, a regular message,
  /// and optionally a stack trace. The string is enclosed in a block of warning symbols.
  @override
  String toString() {
    return '''
 ⛔ ⛔ --------------------------------------------- ⛔ ⛔
$exceptionMessage$message ${stackTrace != '' ? '\n ☠️  Stack Trace ☠️: \n $stackTrace' : ''}
 ⛔ ⛔ --------------------------------------------- ⛔ ⛔
''';
  }
}
