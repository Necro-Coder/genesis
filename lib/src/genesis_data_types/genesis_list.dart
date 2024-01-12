import 'package:genesis/src/genesis_data_types/genesis_base_list.dart';

/// `GList` is a concrete implementation of the `GBaseList` abstract class.
///
/// It provides a list that can interact with a database using the Genesis framework.
///
/// The type parameter `E` represents the type of elements in the list.
class GList<E> extends GBaseList<E> {
  /// Creates a `GList`.
  ///
  /// If [initialElements] is provided, the `GList` is initialized with these elements.
  /// Otherwise, it is initialized as an empty list.
  GList([List<E>? initialElements]) : super(initialElements);
}
