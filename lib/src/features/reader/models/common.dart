class Common {
  final String? name;
  final String? path;

  Common({this.name, this.path});

  factory Common.fromJson(Map<String, dynamic> json) {
    return Common(
      name: json['name'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
    };
  }
}
