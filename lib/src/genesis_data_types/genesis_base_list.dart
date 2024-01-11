import 'dart:collection';

import 'package:genesis/src/features/database/genesis_dao_model.dart';

abstract class GBaseList<E> extends GDaoModel with ListBase<E> {
  final List<E> _innerList;

  GBaseList([List<E>? initialElements]) : _innerList = initialElements ?? [];

  Future<int> gInsert() async {
    return await batchInsert(objectsToInsert: this);
  }

  Future<int> gUpdate() async {
    return await batchUpdate(objectsToUpdate: this);
  }

  Future<int> gDelete() async {
    return await batchDelete(objectsToDelete: this);
  }

  Future<int> gInsertOrUpdate() async {
    return await batchInsertOrUpdate(objects: this);
  }

  Future<int> gInsertOrDelete() async {
    return await batchInsertOrDelete(objects: this);
  }

  @override
  void add(E element) => _innerList.add(element);

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) => _innerList.length = newLength;

  @override
  E operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, E value) => _innerList[index] = value;
}
