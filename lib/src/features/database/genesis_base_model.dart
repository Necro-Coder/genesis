import 'package:genesis/src/features/database/genesis_dao_model.dart';
import 'package:genesis/src/genesis_data_types/genesis_generic_classes/genesis_serializable_object.dart';

class GBaseModel extends GDaoModel {
  static final Map<String, String> _fields = {
    ...GDaoModel.fields,
    'key': 'value',
  };

  static final Iterable<String> _names = _fields.keys;
  static final List<String> _primary = [...GDaoModel.primary, 'primaryField'];
  static final List<String> _exception = [
    ...GDaoModel.exception,
    'exceptionField'
  ];

  static Map<String, String> get fields => _fields;
  static Iterable<String> get names => _names;
  static List<String> get primary => _primary;
  static List<String> get exception => _exception;

  @override
  GenesisSerializableObject fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    return super.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return super.toMap();
  }
}
