import 'dart:convert';

import 'package:rinha/src/models/Person.dart';
import 'package:rinha/src/repositories/person_repository.dart';
import 'package:rinha/src/utils/uuid_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PersonController {
  Handler get handler {
    final router = Router();

    router.post('/pessoas', (Request request) async {
      try {
        final result = await request.readAsString();
        final body = jsonDecode(result);

        final apelido = body['apelido'];
        if (apelido == null || apelido.length > 32) {
          return Response.badRequest(body: 'Apelido too long');
        }
        final nome = body['nome'];
        if (nome == null || nome.length > 100) {
          return Response.badRequest(body: 'Nome too long');
        }
        final nascimento = body['nascimento'];
        if (nascimento == null) {
          return Response.badRequest(body: 'Nascimento is required');
        }
        List<String> stack = body['stack'].cast<String>();
        for (var item in stack) {
          if (item.length > 32) {
            return Response.badRequest(body: 'Stack item too long');
          }
        }
        final uuid = UuidUtils.generateV4();

        await PersonRepository().insert(
          Person(
            uuid: uuid,
            apelido: apelido,
            nome: nome,
            nascimento: nascimento,
            stack: stack,
          ),
        );
        return Response(201, headers: {
          'Location': '/pessoas/$uuid',
        });
      } catch (e) {
        return Response(400, body: e.toString());
      }
    });

    router.get('/pessoas/<id>', (request, id) async {
      try {
        final person = await PersonRepository().get(id);
        if (person == null) {
          return Response.notFound('Person not found');
        }
        return Response.ok(person.toJson(), headers: {
          'Content-Type': 'application/json',
        });
      } catch (e) {
        return Response(400, body: e.toString());
      }
    });

    router.get('/pessoas', (request) async {
      try {
        String? query = request.url.queryParameters['t'];
        if (query == null) {
          return Response(400, body: 'Query parameter "t" is required');
        }
        List<Person> matches = await PersonRepository().search(query);
        final result = matches.map((e) => e.toJson()).toList();
        return Response.ok(result.join('\n'), headers: {
          'Content-Type': 'application/json',
        });
      } catch (e) {
        return Response(400, body: e.toString());
      }
    });

    router.get('/contagem-pessoas', (request) async {
      final count = await PersonRepository().count();
      return Response.ok('$count');
    });

    return router;
  }
}
