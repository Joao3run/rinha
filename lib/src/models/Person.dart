import 'dart:convert';

import '../utils/uuid_utils.dart';

class Person {
  String uuid;
  String apelido;
  String nome;
  String nascimento;
  List<String> stack;

  Person({
    uuid,
    required this.apelido,
    required this.nome,
    required this.nascimento,
    this.stack = const [],
  }) : uuid = uuid ?? UuidUtils.generateV4();

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'apelido': apelido,
      'nome': nome,
      'nascimento': nascimento,
      'stack': stack,
    };
  }

  String toJson() => json.encode(toMap());
}
