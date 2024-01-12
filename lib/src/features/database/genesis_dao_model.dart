import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

import '../../genesis_data_types/genesis_generic_classes/genesis_serializable_object.dart';

abstract class GDaoModel extends Dao implements GenesisSerializableObject {
  /// `int? id;` is declaring a nullable integer variable named `id`. The `?` indicates that the
  /// variable can hold a null value.
  int? id;

  /// `String? createdAt;` is declaring a nullable string variable named `createdAt`. The `?` indicates
  /// that the variable can hold a null value.
  String? createdAt;

  /// `String? updatedAt;` is declaring a nullable string variable named `updatedAt`. The `?` indicates
  /// that the variable can hold a null value.
  String? updatedAt;

  /// The line `static final Map<String, String> _fields = {'id': '${Constants.bigint}
  /// AUTOINCREMENT',};` is declaring a static final variable named `_fields` of type `Map<String,
  /// String>`.
  static final Map<String, String> _fields = {
    'id': '${Constants.bigint} AUTOINCREMENT',
  };

  /// The line `static final Iterable<String> _names = _fields.keys;` is creating a static final
  /// variable named `_names` of type `Iterable<String>`. It is assigning the keys of the `_fields` map
  /// to the `_names` variable. In other words, `_names` will contain all the keys from the `_fields`
  /// map.
  static final Iterable<String> _names = _fields.keys;

  /// The line `static final List<String> _primary = [_names.elementAt(0)];` is declaring a static final
  /// variable named `_primary` of type `List<String>`. It is assigning the first element of the
  /// `_names` iterable to the `_primary` list.
  static final List<String> _primary = [_names.elementAt(0)];

  /// The line `static final List<String> _exception = [];` is declaring a static final variable named
  /// `_exception` of type `List<String>`. It is initializing the `_exception` list as an empty list.
  /// This variable is used to store any exceptions that occur during database operations.
  static final List<String> _exception = [];

  /// The line `static Map<String, String> get fields => _fields;` is creating a static getter method
  /// named `fields` that returns the `_fields` variable.
  static Map<String, String> get fields => _fields;

  /// The line `static Iterable<String> get names => _names;` is creating a static getter method named
  /// `names` that returns the `_names` variable. This allows other classes or methods to access the
  /// `_names` variable without directly accessing it. By using the getter method, the `_names` variable
  /// can be accessed in a read-only manner.
  static Iterable<String> get names => _names;

  /// The line `static List<String> get primary => _primary;` is creating a static getter method named
  /// `primary` that returns the `_primary` variable. This allows other classes or methods to access the
  /// `_primary` variable without directly accessing it. By using the getter method, the `_primary`
  /// variable can be accessed in a read-only manner.
  static List<String> get primary => _primary;

  /// The line `static List<String> get exception => _exception;` is creating a static getter method
  /// named `exception` that returns the `_exception` variable. This allows other classes or methods to
  /// access the `_exception` variable without directly accessing it. By using the getter method, the
  /// `_exception` variable can be accessed in a read-only manner.
  static List<String> get exception => _exception;

  /// The function initializes a GDaoModel object and creates triggers.
  GDaoModel() {
    _createTriggers();
  }

  ///The function is an override method that converts a map to a GenesisSerializableObject.
  ///
  /// Args:
  ///  `map` (Map<String, dynamic>): A map containing key-value pairs where the keys are strings and the
  /// values can be of any type.
  ///
  /// Returns:
  ///  The method is returning a GenesisSerializableObject.
  ///
  /// Throws:
  /// UnimplementedError: The method is not implemented.
  ///
  /// Needs to be implemented in the child class.
  @override
  GenesisSerializableObject fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  /// The function is an override method that converts a GenesisSerializableObject to a map.
  ///
  /// Returns:
  /// The method is returning a map containing key-value pairs where the keys are strings and the values
  /// can be of any type.
  ///
  /// Throws:
  /// UnimplementedError: The method is not implemented.
  ///
  /// Needs to be implemented in the child class.
  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  /// The function inserts a GenesisSerializableObject into a database and returns the number of rows
  /// affected.
  ///
  /// Args:
  ///   `object` (GenesisSerializableObject): The "object" parameter is of type GenesisSerializableObject,
  /// which is an object that can be serialized and inserted into a database.
  ///
  /// Returns:
  ///   The method is returning a `Future<int>`.
  Future<int> insertModel(GenesisSerializableObject object) async {
    return await insertSingle(objectToInsert: this);
  }

  /// The function updates a GenesisSerializableObject asynchronously and returns an integer.
  ///
  /// Args:
  ///   `object` (GenesisSerializableObject): The "object" parameter is of type GenesisSerializableObject.
  ///
  /// Returns:
  ///   The method is returning a `Future<int>`.
  Future<int> update(GenesisSerializableObject object) async {
    return await updateSingle(objectToUpdate: this);
  }

  /// The function deletes a GenesisSerializableObject asynchronously and returns an integer.
  ///
  /// Args:
  ///   `object` (GenesisSerializableObject): The "object" parameter is of type GenesisSerializableObject,
  /// which is an object that can be serialized and deserialized using the Genesis serialization
  /// framework.
  ///
  /// Returns:
  ///   The method is returning a `Future<int>`.
  Future<int> delete(GenesisSerializableObject object) async {
    return await deleteSingle(objectToDelete: this);
  }

  /// The function `selectModel` returns a Future that resolves to a list of `GDaoModel` objects based
  /// on the provided `SqlBuilder` query.
  ///
  /// Args:
  ///   `builder` (SqlBuilder): The `builder` parameter is an instance of the `SqlBuilder` class. It is
  /// required for constructing the SQL query for selecting the model from the database.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `List` of `GDaoModel` objects.
  Future<List<GDaoModel>> selectModel({required SqlBuilder builder}) async {
    return await select<GDaoModel>(sqlBuilder: builder, model: this);
  }

  /// The function returns a Future that retrieves all records from a database table.
  ///
  /// Returns:
  ///   The method `selectAll()` is returning a `Future` object that resolves to a `List` of `GDaoModel`
  /// objects.
  Future<List<GDaoModel>> selectAll() async {
    return await selectModel(builder: _generateDefaultBuilder());
  }

  /// The function `selectWhere` returns a Future that resolves to a list of `GDaoModel` objects based
  /// on the provided list of where conditions.
  ///
  /// Args:
  ///   `whereConditions` (List<String>): The `whereConditions` parameter is a list of conditions. It is
  /// used for constructing the SQL query for selecting the model from the database.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `List` of `GDaoModel` objects.
  Future<List<GDaoModel>> selectWhere(List<String> whereConditions) async {
    return await selectModel(
        builder:
            _generateDefaultBuilder().queryWhere(conditions: whereConditions));
  }

  /// The function `selectById` returns a Future that resolves to a list of `GDaoModel` objects based
  /// on the id of the model.
  ///
  /// It internally calls the `selectWhere` method with a condition that matches the id of the model.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `List` of `GDaoModel` objects.
  Future<List<GDaoModel>> selectById() async {
    return await selectWhere(['id = $id']);
  }

  /// The function `_generateDefaultBuilder` returns an instance of `SqlBuilder` that is set up to
  /// select from the table associated with this model.
  ///
  /// Returns:
  ///   The method is returning an `SqlBuilder` object that is set up with a select query from the
  ///   table associated with this model.
  SqlBuilder _generateDefaultBuilder() {
    return SqlBuilder().querySelect().queryFrom(table: getTableName(this));
  }

  /// The function `_createTriggers` creates a trigger in the database that automatically updates the
  /// `updatedAt` field of a row in the table associated with this model whenever that row is updated.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that completes when the trigger has been created.
  Future<void> _createTriggers() async {
    var db = await getDatabase();

    await db!.execute('''
    CREATE TRIGGER update_updatedAt_${getTableName(this)}
    AFTER UPDATE ON ${getTableName(this)}
    FOR EACH ROW
    BEGIN
       UPDATE ${getTableName(this)} SET updatedAt = datetime('now') WHERE id = NEW.id;
    END;
  ''');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GDaoModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
