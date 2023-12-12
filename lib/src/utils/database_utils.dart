import 'dart:developer';

import 'package:postgres/postgres.dart';

class DatabaseUtils {
  int port = 5432;
  String host = "postgres";
  String databaseName = "postgres";
  String username = "postgres";
  String password = "12345678";
  late final PostgreSQLConnection _connection = PostgreSQLConnection(
    host,
    port,
    databaseName,
    username: username,
    password: password,
  );

  factory DatabaseUtils() => _this;

  static final DatabaseUtils _this = DatabaseUtils._internal();

  DatabaseUtils._internal() : super();

  Future<PostgreSQLConnection> get connection async {
    log("DatabaseUtils - get connection $port $host $databaseName $username $password");
    if (_connection.isClosed) {
      await _connection.open();
    }
    return _connection;
  }
}
