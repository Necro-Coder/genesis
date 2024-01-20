import 'package:genesis/src/features/reader/models/common.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_screen_model.dart';
import 'package:genesis/src/features/reader/models/flutter/genesis_widget_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_file_model.dart';
import 'package:genesis/src/features/reader/models/project/files/genesis_properties_model.dart';
import 'package:genesis/src/features/reader/models/project/genesis_folder_model.dart';

class GCommonList {
  void add(Common common) {}
}

class GFileList extends GCommonList {
  static final List<GFile> _files = [];

  List<GFile> get commons => _files;

  @override
  void add(Common common) {
    _files.add(common as GFile);
  }
}

class GFolderList extends GCommonList {
  static final List<GFolder> _folders = [];

  List<GFolder> get commons => _folders;

  @override
  void add(Common common) {
    _folders.add(common as GFolder);
  }
}

class GPropertyList extends GCommonList {
  static final List<GProperty> _properties = [];

  List<GProperty> get commons => _properties;

  @override
  void add(Common common) {
    _properties.add(common as GProperty);
  }
}

class GScreenList extends GCommonList {
  static final List<GScreen> _screens = [];

  List<GScreen> get commons => _screens;

  @override
  void add(Common common) {
    _screens.add(common as GScreen);
  }
}

class GWidgetList {
  static final List<GWidget> _widgets = [];

  List<GWidget> get commons => _widgets;

  void add(GWidget common) {
    _widgets.add(common);
  }
}
