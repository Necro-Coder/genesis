import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

import '../../genesis_data_types/genesis_generic_classes/genesis_serializable_object.dart';

abstract class GDaoModel extends Dao implements GenesisSerializableObject {
  int? id;
  String? createdAt;
  String? updatedAt;

  static final Map<String, String> _fields = {
    'id': '${Constants.bigint} AUTOINCREMENT',
  };

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [_names.elementAt(0)];
  static final List<String> _exception = [];

  static Map<String, String> get fields => _fields;
  static Iterable<String> get names => _names;
  static List<String> get primary => _primary;
  static List<String> get exception => _exception;

  GDaoModel() {
    _createTriggers();
  }

  @override
  GenesisSerializableObject fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  Future<int> insertModel(GenesisSerializableObject object) async {
    return await insertSingle(objectToInsert: this);
  }

  Future<int> update(GenesisSerializableObject object) async {
    return await updateSingle(objectToUpdate: this);
  }

  Future<int> delete(GenesisSerializableObject object) async {
    return await deleteSingle(objectToDelete: this);
  }

  Future<List<GDaoModel>> selectModel({required SqlBuilder builder}) async {
    return await select<GDaoModel>(sqlBuilder: builder, model: this);
  }

  Future<List<GDaoModel>> selectAll() async {
    return await selectModel(builder: _generateDefaultBuilder());
  }

  Future<List<GDaoModel>> selectWhere(List<String> whereConditions) async {
    return await selectModel(
        builder:
            _generateDefaultBuilder().queryWhere(conditions: whereConditions));
  }

  Future<List<GDaoModel>> selectById() async {
    return await selectWhere(['id = $id']);
  }

  SqlBuilder _generateDefaultBuilder() {
    return SqlBuilder().querySelect().queryFrom(table: getTableName(this));
  }

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
