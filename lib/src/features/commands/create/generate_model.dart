class GenerateModel {
  /// The `generateModelProperties` function generates a string that represents the properties of a model.
  ///
  /// Args:
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the model properties in the correct format for class declaration in Dart.
  ///
  /// This function iterates over each entry in the properties map. For each property, it splits the key by '/' and takes the first element as the property name.
  /// Then, it appends to the properties string a line containing the property type, the property name, and a semicolon.
  String generateModelProperties(Map<String, String> properties) {
    String propertiesString = '';
    for (var property in properties.entries) {
      List<String> propertyDefaultValue = property.key.split('/');
      propertiesString += '  ${property.value} ${propertyDefaultValue[0]};\n';
    }
    return propertiesString;
  }

  /// The `generateModelConstructor` function generates a string that represents the constructor of a model.
  ///
  /// Args:
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the model constructor in the correct format for class declaration in Dart.
  ///
  /// This function iterates over each key in the properties map. For each property, it checks if the property name contains a '?'.
  /// If it does, it removes the '?' and adds the property to the `noNullableProperties` list.
  /// If it doesn't, it adds the property to the `nullableProperties` list.
  /// Then, it iterates over the `nullableProperties` list and the `noNullableProperties` list,
  /// appending to the `constructorString` a line containing the '@required required' keyword and the property default value for each property.
  String generateModelConstructor(Map<String, String> properties) {
    String constructorString = '';
    List<String> nullableProperties = [];
    List<String> noNullableProperties = [];
    for (var property in properties.keys) {
      if (property.contains('?')) {
        noNullableProperties.add(property.replaceAll('?', ''));
      } else {
        nullableProperties.add(property);
      }
    }
    for (var property in nullableProperties) {
      constructorString +=
          '@required required ${getPropertyDefaultValue(property)}, ';
    }
    for (var property in noNullableProperties) {
      constructorString += '${getPropertyDefaultValue(property)}, ';
    }
    return constructorString;
  }

  /// The `getPropertyDefaultValue` function generates a string that represents a property with its default value for a model constructor.
  ///
  /// Args:
  ///   `property` (String): A string that represents the property name and its default value separated by '/'.
  ///
  /// Returns:
  ///   A string that represents the property with its default value in the correct format for a constructor declaration in Dart.
  ///
  /// This function splits the `property` string by '/'. If the resulting list has more than one element,
  /// it means that a default value is provided for the property.
  /// The function then constructs a string that represents the property with its default value in the format 'this.propertyName = defaultValue'.
  /// If no default value is provided, the function constructs a string in the format 'this.propertyName'.
  String getPropertyDefaultValue(String property) {
    List<String> propertyDefaultValue = property.split('/');
    var propertyWithDefaultValue =
        'this.$property${propertyDefaultValue.length > 1 ? ' = ${propertyDefaultValue[1]}' : ''}';
    return propertyWithDefaultValue;
  }

  /// The `generateFromJson` function generates a string that represents the 'fromJson' method of a model.
  ///
  /// Args:
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the 'fromJson' method in the correct format for class declaration in Dart.
  ///
  /// This function iterates over each key in the properties map. For each property, it appends to the `fromJsonString` a line
  /// containing the property name and the corresponding json value in the format 'propertyName: json['propertyName'],'
  String generateFromJson(Map<String, String> properties) {
    String fromJsonString = '';
    for (var property in properties.keys) {
      fromJsonString += '$property: json[\'$property\'],\n';
    }
    return fromJsonString;
  }

  /// The `generateToJson` function generates a string that represents the 'toJson' method of a model.
  ///
  /// Args:
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the 'toJson' method in the correct format for class declaration in Dart.
  ///
  /// This function iterates over each key in the properties map. For each property, it appends to the `toJsonString` a line
  /// containing the property name and the corresponding property value in the format ''propertyName': propertyName,'
  String generateToJson(Map<String, String> properties) {
    String toJsonString = '';
    for (var property in properties.keys) {
      toJsonString += '\'$property\': $property,\n';
    }
    return toJsonString;
  }

  /// The `generateDatabaseMethods` function generates a string that represents the database methods of a model.
  ///
  /// Args:
  ///   `database` (bool): A boolean that indicates whether the model is linked to a database.
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the database methods in the correct format for class declaration in Dart.
  ///
  /// This function checks if the `database` argument is true. If it is, it generates a string that represents the database methods of the model,
  /// which includes the fields, the primary key, the exceptions, the foreign keys, and the database getters.
  /// If the `database` argument is false, it returns an empty string.
  String generateDatabaseMethods(
      bool database, Map<String, String> properties) {
    if (database) {
      return '''
    ${_generateFields(properties)}

    static final Iterable<String> _names = _fields.keys;

    ${_generatePrimary()}
    ${_generateExceptions()}

    ${_generateForeign()}

    ${_generateDatabaseGetters()}
  ''';
    }
    return '';
  }

  /// The `_generateFields` function generates a string that represents the fields of a model for a database.
  ///
  /// Args:
  ///   `properties` (Map<String, String>): A map where the key is the property name and the value is the property type.
  ///
  /// Returns:
  ///   A string that represents the fields in the correct format for class declaration in Dart.
  ///
  /// This function iterates over each entry in the properties map. For each property, it splits the key by '/' and takes the first element as the property name.
  /// Then, it checks the property type and assigns the corresponding value from the `Constants` class.
  /// Finally, it appends to the `fieldsString` a line containing the property name and the corresponding value in the format ''propertyName': value,'
  String _generateFields(Map<String, String> properties) {
    String fieldsString = 'static final Map<String, String> _fields = {\n';
    for (var property in properties.entries) {
      List<String> propertyDefaultValue = property.key.split('/');
      String value = '';
      switch (property.value) {
        case 'int':
          value = 'Constants.integer';
          break;
        case 'String':
          value = 'Constants.varchar[\'255\']!';
          break;
        case 'bool':
          value = 'Constants.boolean';
          break;
        case 'DateTime':
          value = 'Constants.datetime';
          break;
        case 'double':
          value = 'Constants.decimal[\'9,2\']!';
          break;
        default:
          value = 'Constants.varchar[\'255\']!';
      }
      fieldsString += '    \'${propertyDefaultValue[0]}\': $value,\n';
    }
    return fieldsString;
  }

  String _generatePrimary() {
    return '';
  }

  String _generateDatabaseGetters() {
    return '';
  }

  String _generateExceptions() {
    return '';
  }

  String _generateForeign() {
    return '';
  }
}
