import 'dart:io';

import 'package:genesis/src/helpers/console_color.dart';

class Help {
  /// The `printHelp` function prints to the console the help corresponding to the provided argument.
  ///
  /// Args:
  ///   `argument` (String): The argument for which the help will be printed. Valid arguments are:
  ///   'all', 'database', 'help', 'init', 'create', 'delete', 'preferences'. If an invalid argument
  ///   is provided, an error message will be printed.
  ///
  /// Returns:
  ///   None.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// Depending on the provided argument, a specific help function is called that prints the
  /// corresponding help. If the 'all' argument is provided, all help functions will be called.
  void printHelp(String argument) {
    //TODO: Add the documentation link
    stdout.write(ConsoleColor.penSecondary('Thanks for using Genesis!! ✨✨\n\n'
        '(For more information go to genesis_README.md or official documentation on #~~#~#~#~#~# )\n\n'
        '${ConsoleColor.penWarning('-> dart run genesis.. \n')}'));
    switch (argument) {
      case 'all':
        _getHelpHelp();
        _getInitHelp();
        _getDatabaseHelp();
        _getCreateHelp();
        _getDeleteHelp();
        _getPreferencesHelp();
        break;
      case 'database':
        _getDatabaseHelp();
        break;
      case 'help':
        _getHelpHelp();
        break;
      case 'init':
        _getInitHelp();
        break;
      case 'create':
        _getCreateHelp();
        break;
      case 'delete':
        _getDeleteHelp();
        break;
      case 'preferences':
        _getPreferencesHelp();
        break;
      default:
        stdout.write(ConsoleColor.penError(
            'Command not found. Type `help all` to see the available commands'));
    }
  }

  /// The `_getDatabaseHelp` function prints to the console the help for the database commands.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to change the database name and version, how to add
  /// and remove tables from the database, and how to add or remove constants.
  void _getDatabaseHelp() {
    stdout.write(ConsoleColor.penInfo('..database\n'
        '\t--name <Database Name>\n'
        '\t# Change the database name #\n\n'
        '\t--version <Database Version>\n'
        '\t# Change the database version #\n\n'
        '\t--table -a\n'
        '\t# Looks into the models folder in genesis.gs and add the models type into the tables of the database #\n\n'
        '\t--table <Table Name>\n'
        '\t# Add a new table to the database #\n\n'
        '\t --table -d <Table Route>\n'
        '\t# Add a new table to the database looking for the route. If ends in extension, add the data type, else, looks for the folder and add all the data types #\n\n'
        '\t--table  -r <Table Name>\n'
        '\t# Remove a table from the database #\n\n'
        '\t--constants [-a/-r/-i] <Table Route>\n'
        '\t# Add o remove a constant to the list #\n'
        '\t\t# -a -> Add a new constant #\n'
        '\t\t# -r -> Remove a constant #\n'
        '\t\t# -i -> Info. Print on console the available constants #\n\n'));
  }

  /// The `_getHelpHelp` function prints to the console the help for the help command.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to use the help command.
  void _getHelpHelp() {
    stdout.write(ConsoleColor.penInfo(
        '..help [<Command>/all]\n# Print help on console #\n\n'));
  }

  /// The `_getInitHelp` function prints to the console the help for the init command.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to use the init command to initialize the package,
  /// which creates the genesis.gs file and the genesis_README.md.
  void _getInitHelp() {
    stdout.write(ConsoleColor.penInfo('..init\n'
        '# Initialize the package. It creates the genesis.gs file and the genesis_README.md #\n\n'));
  }

  /// The `_getCreateHelp` function prints to the console the help for the create command.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to use the create command to create the structure
  /// on genesis.gs file, create a new model in the models folder, create a new entity in the entities
  /// folder, create a new screen in the screens folder, and create a new widget in the widgets folder.
  void _getCreateHelp() {
    stdout.write(ConsoleColor.penInfo('..create\n'
        '\t# Create the structure on genesis.gs file #\n\n'
        '\t--model <Model Name>\n'
        '\t# Create a new model in the models folder you declare on genesis.gs #\n\n'
        '\t--entity <Entity Name>\n'
        '\t# Create a new entity in the entities folder you declare on genesis.gs #\n\n'
        '\t--screen [-f/-l] <Screen Name>\n'
        '\t# Create a new screen in the screens folder you declare on genesis.gs #\n'
        '\t\t# -f -> Create a StateFull widget #\n'
        '\t\t# -l -> Create a StateLess widget #\n\n'
        '\t--widget <Widget Name>\n'
        '\t# Create a new widget in the widgets folder you declare on genesis.gs #\n\n'));
  }

  /// The `_getDeleteHelp` function prints to the console the help for the delete command.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to use the delete command to delete a model in the
  /// models folder, delete an entity in the entities folder, delete a screen in the screens folder,
  /// and delete a widget in the widgets folder.
  void _getDeleteHelp() {
    stdout.write(ConsoleColor.penInfo('..delete\n'
        '\t--model <Model Name>\n'
        '\t# Delete a model in the models folder you declare on genesis.gs #\n\n'
        '\t--entity <Entity Name>\n'
        '\t# Delete an entity in the entities folder you declare on genesis.gs #\n\n'
        '\t--screen <Screen Name>\n'
        '\t# Delete a screen in the screens folder you declare on genesis.gs #\n\n'
        '\t--widget <Widget Name>\n'
        '\t# Delete a widget in the widgets folder you declare on genesis.gs #\n\n'));
  }

  /// The `_getPreferencesHelp` function prints to the console the help for the preferences command.
  ///
  /// This function uses the `ConsoleColor` class to color the text that is printed to the console.
  /// The printed help includes information on how to use the preferences command to add a new
  /// preference value to preferences.dart located on genesis.gs and to remove a preference value
  /// from preferences.dart located on genesis.gs.
  void _getPreferencesHelp() {
    stdout.write(ConsoleColor.penInfo('..preferences\n'
        '\t--add <Preference Name> <Preference type>\n'
        '\t# Add a new preference value to preferences.dart located on genesis.gs #\n\n'
        '\t--remove <Preference Name>\n'
        '\t# Remove a preference value from preferences.dart located on genesis.gs #\n\n'));
  }
}
