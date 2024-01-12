import 'package:ansicolor/ansicolor.dart';

/// `ConsoleColor` is a utility class that provides predefined `AnsiPen` instances for console text coloring.
///
/// Each `AnsiPen` instance corresponds to a different color, allowing you to easily change the color of console text.
///
/// Example usage:
/// ```dart
/// print(ConsoleColor.penError('This is an error message'));
/// print(ConsoleColor.penSuccess('This is a success message'));
/// ```
class ConsoleColor {
  /// `penError` is an `AnsiPen` instance that colors text red.
  ///
  /// Use this for error messages.
  static AnsiPen penError = AnsiPen()..red();

  /// `penWarning` is an `AnsiPen` instance that colors text yellow.
  ///
  /// Use this for warning messages.
  static AnsiPen penWarning = AnsiPen()..yellow();

  /// `penInfo` is an `AnsiPen` instance that colors text blue.
  ///
  /// Use this for informational messages.
  static AnsiPen penInfo = AnsiPen()..blue();

  /// `penSuccess` is an `AnsiPen` instance that colors text green.
  ///
  /// Use this for success messages.
  static AnsiPen penSuccess = AnsiPen()..green();

  /// `penPrimary` is an `AnsiPen` instance that colors text cyan.
  ///
  /// Use this for primary messages.
  static AnsiPen penPrimary = AnsiPen()..cyan();

  /// `penSecondary` is an `AnsiPen` instance that colors text magenta.
  ///
  /// Use this for secondary messages.
  static AnsiPen penSecondary = AnsiPen()..magenta();

  /// `penAccent` is an `AnsiPen` instance that colors text white.
  ///
  /// Use this for accent messages.
  static AnsiPen penAccent = AnsiPen()..white();

  /// `penAccent2` is an `AnsiPen` instance that colors text gray.
  ///
  /// Use this for secondary accent messages.
  static AnsiPen penAccent2 = AnsiPen()..gray();
}
