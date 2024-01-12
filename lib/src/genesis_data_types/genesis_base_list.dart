import 'dart:collection';

import 'package:genesis/src/features/database/genesis_dao_model.dart';

/// `GBaseList` is an abstract class that extends `GDaoModel` and mixes in `ListBase`.
///
/// It provides a base implementation for a list that can interact with a database using the Genesis framework.
///
/// The type parameter `E` represents the type of elements in the list.
abstract class GBaseList<E> extends GDaoModel with ListBase<E> {
  /// `_innerList` is a private list that stores the elements of the `GBaseList`.
  final List<E> _innerList;

  /// Creates a `GBaseList`.
  ///
  /// If [initialElements] is provided, the `GBaseList` is initialized with these elements.
  /// Otherwise, it is initialized as an empty list.
  GBaseList([List<E>? initialElements]) : _innerList = initialElements ?? [];

  /// Inserts all elements of the list into the database.
  ///
  /// Returns a `Future` that completes with the number of rows inserted.
  Future<int> gInsert() async {
    return await batchInsert(objectsToInsert: this);
  }

  /// Updates all elements of the list in the database.
  ///
  /// Returns a `Future` that completes with the number of rows updated.
  Future<int> gUpdate() async {
    return await batchUpdate(objectsToUpdate: this);
  }

  /// Deletes all elements of the list from the database.
  ///
  /// Returns a `Future` that completes with the number of rows deleted.
  Future<int> gDelete() async {
    return await batchDelete(objectsToDelete: this);
  }

  /// Inserts or updates all elements of the list in the database.
  ///
  /// Returns a `Future` that completes with the number of rows inserted or updated.
  Future<int> gInsertOrUpdate() async {
    return await batchInsertOrUpdate(objects: this);
  }

  /// Inserts or deletes all elements of the list in the database.
  ///
  /// Returns a `Future` that completes with the number of rows inserted or deleted.
  Future<int> gInsertOrDelete() async {
    return await batchInsertOrDelete(objects: this);
  }

  /// Adds [element] to the end of the list.
  @override
  void add(E element) => _innerList.add(element);

  /// Returns the number of elements in the list.
  @override
  int get length => _innerList.length;

  /// Changes the length of the list.
  ///
  /// If [newLength] is greater than the current length, entries are initialized to `null`.
  @override
  set length(int newLength) => _innerList.length = newLength;

  /// Returns the element at the given [index] in the list.
  @override
  E operator [](int index) => _innerList[index];

  /// Sets the [value] at the given [index] in the list.
  @override
  void operator []=(int index, E value) => _innerList[index] = value;
}
