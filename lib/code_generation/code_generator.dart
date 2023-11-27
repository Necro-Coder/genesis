import 'dart:io';

abstract class CodeGenerator {
  String toCamelCase(String input) {
    List<String> words = input.split('_');
    return words
        .map((word) =>
    word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join();
  }

  void createDirectory(String path) {
    stdout.writeln('Path: $path');
    if(!Directory(path).existsSync()) Directory(path).createSync(recursive: true);
  }

  void createDirectories(List<String> paths) {
    for (var path in paths) {
      createDirectory(path);
    }
  }

  void createFiles(Map<String, String> files) {
    for (var file in files.keys) {
      createFileWithComment(file, files[file]!);
    }
  }

  void createFileWithComment(String path, String comment) {
    stdout.writeln('Path: $path');
    stdout.writeln('Content: $comment');
    if(!File(path).existsSync()){
      File(path)
        ..createSync(recursive: true)
        ..writeAsStringSync(comment);
    }
  }
}