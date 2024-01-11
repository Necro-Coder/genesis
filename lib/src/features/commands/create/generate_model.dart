class GenerateModel {
  String generateModelProperties(Map<String, String> properties) {
    String propertiesString = '';
    for (var property in properties.entries) {
      List<String> propertyDefaultValue = property.key.split('/');
      propertiesString += '  ${property.value} ${propertyDefaultValue[0]};\n';
    }
    return propertiesString;
  }

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

  String getPropertyDefaultValue(String property) {
    List<String> propertyDefaultValue = property.split('/');
    var propertyWithDefaultValue =
        'this.$property${propertyDefaultValue.length > 1 ? ' = ${propertyDefaultValue[1]}' : ''}';
    return propertyWithDefaultValue;
  }

  String generateFromJson(Map<String, String> properties) {
    String fromJsonString = '';
    for (var property in properties.keys) {
      fromJsonString += '$property: json[\'$property\'],\n';
    }
    return fromJsonString;
  }

  String generateToJson(Map<String, String> properties) {
    String toJsonString = '';
    for (var property in properties.keys) {
      toJsonString += '\'$property\': $property,\n';
    }
    return toJsonString;
  }

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
