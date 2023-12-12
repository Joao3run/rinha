import 'package:rinha/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final server = await io.serve(
      Pipeline()
          .addMiddleware(
            logRequests(),
          )
          .addHandler(
            App().handler,
          ),
      '0.0.0.0',
      8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
