import 'dart:io';

import 'package:genesis/src/features/error_control/exceptions.dart';
import 'package:genesis/src/helpers/console_color.dart';

class Init {
  /// The function `init` initializes the Genesis framework by creating necessary files and folders
  /// in the root of the project. It first asks for user's confirmation before proceeding.
  ///
  /// The method does not return a value. It writes to the standard output to inform the user about
  /// the progress of the initialization process. If the user confirms the initialization, it calls
  /// the `_createGenesisFolder` method to create the necessary files and folders, and then informs
  /// the user that Genesis was initialized successfully. If the user cancels the initialization,
  /// it informs the user that Genesis was canceled.
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

  /// The function `_createGenesisFolder` creates a new directory named 'genesis' in the 'lib' directory
  /// of the project. It also creates a Genesis file and a README file in the newly created directory.
  ///
  /// The method does not return a value. It writes to the standard output to inform the user about
  /// the progress of the directory creation. It then calls the `_createGenesisFile` and
  /// `_createGenesisReadme` methods to create the Genesis file and the README file, respectively.
  void _createGenesisFolder() {
    stdout.write(ConsoleColor.penInfo('Creating genesis folder...\n'));
    Directory directory = Directory('lib/genesis');
    directory.createSync();
    _createGenesisFile(directory.path);
    _createGenesisReadme(directory.path);
  }

  /// The function `_createGenesisFile` creates a new file named 'genesis.gs' in the specified directory.
  /// It first writes to the standard output to inform the user that it is creating the 'genesis.gs' file.
  /// It then calls the `_writeGenesisFile` method to write to the 'genesis.gs' file.
  ///
  /// Args:
  ///   `directoryPath` (String): The path of the directory where the 'genesis.gs' file will be created.
  ///
  ///   The method does not return a value. If the file creation is successful, it writes to the standard
  ///   output to inform the user that the 'genesis.gs' file was created successfully. If an error occurs
  ///   during the file creation, it throws an error using the `Exceptions().throwErrorCreatingGenesisFile(e)`
  ///   method.
  void _createGenesisFile(String directoryPath) {
    stdout.write(ConsoleColor.penInfo('Creating genesis.gs file...\n'));
    File genesisFile = _writeGenesisFile('$directoryPath/genesis.gs');
    try {
      genesisFile.createSync();
    } catch (e) {
      Exceptions().throwErrorCreatingGenesisFile('genesis.gs', e);
    }
    stdout.write(ConsoleColor.penSuccess(
        'genesis.gs file was created successfully on `${genesisFile.absolute.path}`\n'));
  }

  /// The function `_createGenesisReadme` creates a new file named 'genesis_README.md' in the specified directory.
  /// It first writes to the standard output to inform the user that it is creating the 'genesis_README.md' file.
  /// It then calls the `_writeGenesisReadme` method to write to the 'genesis_README.md' file.
  ///
  /// Args:
  ///   `directoryPath` (String): The path of the directory where the 'genesis_README.md' file will be created.
  ///
  ///   The method does not return a value. If the file creation is successful, it writes to the standard
  ///   output to inform the user that the 'genesis_README.md' file was created successfully. If an error occurs
  ///   during the file creation, it throws an error using the `Exceptions().throwErrorCreatingGenesisFile('genesis_README.md', e)`
  ///   method.
  void _createGenesisReadme(String directoryPath) {
    stdout.write(ConsoleColor.penInfo('Writing genesis_README.md file...\n'));
    File genesisReadme =
        _writeGenesisReadme('$directoryPath/genesis_README.md');
    try {
      genesisReadme.createSync();
    } catch (e) {
      Exceptions().throwErrorCreatingGenesisFile('genesis_README.md', e);
    }
    stdout.write(ConsoleColor.penSuccess(
        'genesis_README.md file was created successfully on `${genesisReadme.absolute.path}`\n'));
  }

  /// The function `_writeGenesisFile` creates a new file at the specified path and writes a predefined
  /// content to it. The content is a string that contains comments and a proposed structure for a clean
  /// code project.
  ///
  /// Args:
  ///   `path` (String): The path where the new file will be created.
  ///
  /// Returns:
  ///   `genesisFile` (File): The newly created file with the predefined content written to it.
  ///
  /// This function uses the `File` class from the `dart:io` library to create the file and write to it.
  /// The `writeAsStringSync` method is used to write the content to the file. If the file already exists,
  /// this method overwrites it. If the file does not exist, this method creates it.
  File _writeGenesisFile(String path) {
    var content = '''
    -- This is a simple comment.
!--
This is a block comment.
--!

!--
On this file you can define your project structure.

In order to generate the code, you need to follow the next sintaxis:

    Routes to generate the code for the models: 
    Name: Models. Ignore case. 

    Routes to generate the code for screens:
    Name: Screens. Ignore case.

    Routes to generate the code for widgets:
    Name: Widgets. Ignore case.

    All these routes will be mark with a '*'.

This structure is simple. For define the basic structure, you use tabulations as you can see on the example.
In the example, the folder (f) 'Database' is inside the folder (f) 'Domain' witch is inside the folder 'lib'.

The files (d) are files that will be generated. This files contains properites (p).

Is important to go to these files and complete the TODOs.

This package generate the basic code to use the models in the database.

You can create these model files manually, but is recommended to use this package to generate the code
because this package will generate the code for the models and the code for the database, add these models 
to the database tables and create a metadata log file to keep track of the changes.

In order to generate the screens (s) and the widgets (w) files, you will have some templates to use.
This templates are on the official documentation with examples.

________________________________________________________________________________________________________________
IMPORTANT!

-> You must add a empty line at the end of the content of the folder like you can see on the example.
This is to make easer the comprenhension of the file and to avoid errors.

-> If your tabulation spaces are less than 4, you must type 4 spaces instead. 
________________________________________________________________________________________________________________


The code generated by this package is not perfect, but is a good start point.

Enjoy it! 😄
--!

(f) name: Domain
    (f) name: Database
        (f) name: Models, *
            (d) name: ModelExample1
                (p) name: name, type: string, primary: true
                (p) name: age, type: int, value: 10
                (p) name: groupId, type: int, foreign: true, model: Group
            (d) name: ModelExample2
                (p) name: name, type: double, primary: primary, foreign: foreign, table: table
                (p) name: name, type: bool, primary: primary, foreign: foreign, table: table
                (p) name: name, type: type, DateTime: value, primary: primary, foreign: foreign, table: table
                (p) name: name, type: type, primary: primary, foreign: foreign, table: table
            (d) name: ModelExample3
                (p) name: name, type: type, primary: primary, foreign: foreign, table: table
                (p) name: name, type: type, primary: primary, foreign: foreign, table: table
                (p) name: name, type: type, primary: primary, foreign: foreign, table: table
                (p) name: name, type: type, primary: primary, foreign: foreign, table: table

(f) name: Repository
    (f) name: Database
        (f) name: Entity

(f) name: Presentation
    (f) name: Screens, *
        (s) name: HomeScreen, template: Home
        (s) name: LoginScreen, state: true
    (f) name: Widgets, *
        (w) name: CustomWidget, template: Box
    ''';
    File genesisFile = File(path);
    genesisFile.writeAsStringSync(content);
    return genesisFile;
  }

  /// The function `_writeGenesisReadme` creates a new file at the specified path and writes the content
  /// of an existing file to it. The existing file is located at './lib/data_util/readme.md'.
  ///
  /// Args:
  ///   `path` (String): The path where the new file will be created.
  ///
  /// Returns:
  ///   `genesisReadme` (File): The newly created file with the content of the existing file written to it.
  ///
  /// This function uses the `File` class from the `dart:io` library to create the file and write to it.
  /// The `readAsStringSync` method is used to read the content of the existing file and the
  /// `writeAsStringSync` method is used to write this content to the new file. If the new file already
  /// exists, this method overwrites it. If the new file does not exist, this method creates it.
  File _writeGenesisReadme(String path) {
    var content = '';
    File genesisReadme = File(path);
    genesisReadme.writeAsStringSync(content);
    return genesisReadme;
  }
}
