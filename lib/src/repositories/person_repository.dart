import 'dart:convert';

import 'package:rinha/src/models/Person.dart';

import '../utils/database_utils.dart';

class PersonRepository {
  factory PersonRepository() => _this;

  static final PersonRepository _this = PersonRepository._getInstance();

  PersonRepository._getInstance() : super();

  Future<void> insert(Person person) async {
    final conn = await DatabaseUtils().connection;
    await conn.query(
      'INSERT INTO pessoa (uuid, apelido, nome, nascimento, stack) VALUES (@uuid, @apelido, @nome, @nascimento, @stack)',
      substitutionValues: {
        'uuid': person.uuid,
        'apelido': person.apelido,
        'nome': person.nome,
        'nascimento': person.nascimento,
        'stack': jsonEncode(person.stack),
      },
    );
  }

  Future<int> count() async {
    final conn = await DatabaseUtils().connection;
    final result = await conn.query(
      'SELECT COUNT(1) FROM pessoa',
    );
    return result[0][0] as int;
  }

  Future<Person?> get(id) async {
    final conn = await DatabaseUtils().connection;
    final result = await conn.query(
      "SELECT uuid, apelido, nome, to_char(nascimento, 'YYYY-MM-DD') as nascimento, stack FROM pessoa WHERE uuid = @uuid",
      substitutionValues: {
        'uuid': id,
      },
    );
    if (result.isEmpty) {
      return null;
    }
    final row = result[0];
    return Person(
      uuid: row[0] as String,
      apelido: row[1] as String,
      nome: row[2] as String,
      nascimento: row[3],
      stack: (row[4] as List<dynamic>).cast<String>(),
    );
  }

  Future<List<Person>> search(String query) async {
    final conn = await DatabaseUtils().connection;
    final result = await conn.query(
      "SELECT uuid, apelido, nome, to_char(nascimento, 'YYYY-MM-DD') as nascimento, stack FROM pessoa WHERE search like '%$query%' limit 50",
      substitutionValues: {
        'query': query,
      },
    );
    return result.map((e) {
      return Person(
        uuid: e[0] as String,
        apelido: e[1] as String,
        nome: e[2] as String,
        nascimento: e[3],
        stack: (e[4] as List<dynamic>).cast<String>(),
      );
    }).toList();
  }
}
