import 'package:ansicolor/ansicolor.dart';

class ConsoleColor {
  static AnsiPen penError = AnsiPen()..red();
  static AnsiPen penWarning = AnsiPen()..yellow();
  static AnsiPen penInfo = AnsiPen()..blue();
  static AnsiPen penSuccess = AnsiPen()..green();
  static AnsiPen penPrimary = AnsiPen()..cyan();
  static AnsiPen penSecondary = AnsiPen()..magenta();
  static AnsiPen penAccent = AnsiPen()..white();
  static AnsiPen penAccent2 = AnsiPen()..gray();
}
