import 'package:rinha/src/controllers/person_controller.dart';
import 'package:shelf/shelf.dart';

class App {
  Handler get handler {
    Cascade cascade = Cascade().add(PersonController().handler);
    return cascade.handler;
  }
}
