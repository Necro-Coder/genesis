class GenesisException implements Exception {
  final String message;
  final String stackTrace;
  String exceptionMessage = '';

  get getExceptionMessage => exceptionMessage;

  set setExceptionMessage(final exceptionMessage) =>
      this.exceptionMessage = exceptionMessage;

  GenesisException(this.message, {this.stackTrace = ''});

  @override
  String toString() {
    return '''
 ⛔ ⛔ --------------------------------------------- ⛔ ⛔
$exceptionMessage$message ${stackTrace != '' ? '\n ☠️  Stack Trace ☠️: \n $stackTrace' : ''}
 ⛔ ⛔ --------------------------------------------- ⛔ ⛔
''';
  }
}
