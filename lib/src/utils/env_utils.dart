import 'dart:io';

class EnvUtils {
  final Map<String, String> _env = {};

  static final EnvUtils _this = EnvUtils._getInstance();

  EnvUtils._getInstance() {
    _load();
  }

  factory EnvUtils() => _this;

  String get(String key) {
    return _env[key] ?? '';
  }

  _load() async {
    final lines = (await _readEnvFile()).split('\n');
    for (final line in lines) {
      final keyValue = line.split('=');
      if (keyValue.length == 2) {
        _env[keyValue[0]] = keyValue[1];
      }
    }
  }

  Future<String> _readEnvFile() async {
    return await File('.env').readAsString();
  }
}
