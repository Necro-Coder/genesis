import 'package:genesis/src/features/reader/models/common.dart';

class GCommonList {
  static final List<Common> _commons = [];

  List<Common> get commons => _commons;

  void add(Common common) {
    _commons.add(common);
  }
}

class GFileList extends GCommonList {}

class GFolderList extends GCommonList {}

class GPropertyList extends GCommonList {}

class GScreenList extends GCommonList {}

class GWidgetList extends GCommonList {}
