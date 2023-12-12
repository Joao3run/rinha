import 'package:uuid/uuid.dart';

class UuidUtils {
  static String generateV4() {
    final String uuid = Uuid().v4();
    return uuid;
  }
}
