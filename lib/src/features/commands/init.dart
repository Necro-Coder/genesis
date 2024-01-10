import 'dart:io';

import 'package:genesis/src/helpers/console_color.dart';

class Init {
  void init() {
    stdout.write(ConsoleColor.penWarning(
        'Genesis is going to create files and folders in the root of the project, do you agree? (Y/n)'));
    var input = stdin.readLineSync();
    if (input == 'Y' || input == 'y' || input == '') {
      _createGenesisFolder();
      stdout.write(
          ConsoleColor.penSuccess('Genesis was initialized successfully\n'));
      stdout.write(
          'Now you can go to `lib/genesis/genesis_README.md` to learn how to use Genesis\n');
    } else {
      stdout.write(ConsoleColor.penInfo('Genesis was canceled\n'));
      return;
    }
  }

  void _createGenesisFolder() {
    stdout.write(ConsoleColor.penInfo('Creating genesis folder...\n'));
    Directory directory = Directory('genesis');
    directory.createSync();
    _createGenesisFile(directory.path);
    _createGenesisReadme(directory.path);
  }

  void _createGenesisFile(String directoryPath) {
    stdout.write(ConsoleColor.penInfo('Creating genesis.gs file...\n'));
    File genesisFile = _writeGenesisFile('$directoryPath/genesis.gs');
    try {
      genesisFile.createSync();
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while creating the genesis.gs file\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return;
    }
    stdout.write(ConsoleColor.penSuccess(
        'genesis.gs file was created successfully on `${genesisFile.absolute.path}`\n'));
  }

  void _createGenesisReadme(String directoryPath) {
    stdout.write(ConsoleColor.penInfo('Writing genesis_README.md file...\n'));
    File genesisReadme =
        _writeGenesisReadme('$directoryPath/genesis_README.md');
    try {
      genesisReadme.createSync();
    } catch (e) {
      stdout.write(ConsoleColor.penError(
          'An error occurred while creating the genesis_README.md file\n'));
      stdout.write(ConsoleColor.penError(e.toString()));
      return;
    }
    stdout.write(ConsoleColor.penSuccess(
        'genesis_README.md file was created successfully on `${genesisReadme.absolute.path}`\n'));
  }

  File _writeGenesisFile(String path) {
    var content = '''
-- This is a comment on .gs files. You can use it to write some notes about the file or the project
-- And this are the things that can be counterintuitive:
-- `F`: Folder
-- `D`: File
-- `-`: Property (Is important to add a space after the hyphen)
-- `!`: This file will be skipped by the analyzer
-- `?`: This property is not nullable on database and code
-- `*`: Is complete necessary to add this symbol to identify the generation files folders
-- `#`: This file will be created but not added to the database
-- `/DefaultValue`: This property will have a default value
-- `full`: This file will be a StateFullWidget
-- `less`: This file will be a StateLessWidget
-- `cubit`: This file will be a Cubit
-- You can delete this comment. If you want to know more about the structure, go to genesis_README.md
-- Now, I propose a basic clean code structure for you to start working
-- This is the structure of the project:

Domain F
__Database F
___Models F *
____Model1 D
_____- Property1/0 int
_____- Property2 string
_____- Property3/false bool
_____- Property4 DateTime ?
____Model2 D
_____- Property1 int
_____- Property2 string
_____- Property3 bool
_____- Property4 DateTime ?
____Model3 D #
_____- Property1 int
_____- Property2 string
_____- Property3 double
_____- Property4 DateTime ?
____Parameters D

___Preferences F *

Repository F
__Database F
___Entity F *
-- The same as Domain.Database.Models but designed to be used by the repository
-- If want some more entities, add them below
____Entity1 D
_____- Property1/0 int
_____- Property2 string
_____- Property3 bool
_____- Property4 DateTime ?
_____- Property5 double ?

Presentation F
__Screens F *
___HomeScreen D full
___LoginScreen D less
__Widgets F *
__Blocks F *
___ApiBloc D
___RouterBloc D cubit
''';
    File genesisFile = File(path);
    genesisFile.writeAsStringSync(content);
    return genesisFile;
  }

  File _writeGenesisReadme(String path) {
    var content = File('./lib/data_util/readme.md').readAsStringSync();
    File genesisReadme = File(path);
    genesisReadme.writeAsStringSync(content);
    return genesisReadme;
  }
}
