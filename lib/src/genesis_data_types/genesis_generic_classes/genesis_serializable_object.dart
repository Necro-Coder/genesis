/// `GenesisSerializableObject` is a base class for objects that can be serialized to and from a map.
///
/// It provides a basic implementation of serialization and deserialization methods.
class GenesisSerializableObject {
  /// Creates a `GenesisSerializableObject` from a [map].
  ///
  /// This base implementation does not actually use the [map], and simply returns `this`.
  /// Subclasses should override this method to provide actual deserialization logic.
  GenesisSerializableObject fromMap(Map<String, dynamic> map) {
    return this;
  }

  /// Converts the `GenesisSerializableObject` to a map.
  ///
  /// This base implementation returns an empty map.
  /// Subclasses should override this method to provide actual serialization logic.
  Map<String, dynamic> toMap() {
    return {};
  }
}
