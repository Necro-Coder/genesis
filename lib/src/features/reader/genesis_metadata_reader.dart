import 'dart:io';

class GMetadataReader {
  Future<String> read() async {
    final file = File('/lib/genesis/genesis.metadata.json');
    final json = await file.readAsString();
    return json.split('---')[0];
  }
}
