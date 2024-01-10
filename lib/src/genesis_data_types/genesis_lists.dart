import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

abstract class GList<E> extends Dao implements Iterable<E>, List<E> {
  Future<int> insertInto() async {
    return await batchInsert(objectsToInsert: this);
  }

  Future<int> delete() async {
    return await batchDelete(objectsToDelete: this);
  }

  Future<int> update() async {
    return await batchUpdate(objectsToUpdate: this);
  }

  Future<int> upsert() async {
    return await batchInsertOrUpdate(objects: this);
  }

  Future<int> delesert() async {
    return await batchInsertOrDelete(objects: this);
  }

  @override
  E operator [](int index);

  @override
  void operator []=(int index, E value);
}
