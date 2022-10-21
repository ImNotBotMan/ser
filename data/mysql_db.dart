// ignore_for_file: cast_nullable_to_non_nullable, leading_newlines_in_multiline_strings

import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';

import '../models/data/list_data_model.dart';
import '../models/user/login.dart';

abstract class IDataSourse {
  Future<List<ItemDataModel>> getData(String userId);
  Future<bool> addItem(ItemDataModel model);
  Future<bool> removeItem(String id);
  Future<ItemDataModel?> getItemById({
    required String userId,
    required String itemId,
  });
  Future<bool> completeItem({
    required String userId,
    required String itemId,
  });
  Future<bool> createUser(RegisterModel registerModel);
  Future<bool> isExistUser(RegisterModel registerModel);
}

class MySqlDataSourse implements IDataSourse {
  factory MySqlDataSourse() {
    return _singleton;
  }

  MySqlDataSourse._internal() {
    init();
  }
  late MySQLConnection connection;
  static final MySqlDataSourse _singleton = MySqlDataSourse._internal();

  Future<void> init() async {
    connection = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '212001art',
      databaseName: 'todo',
    );
    await connection.connect();
    log('CONNECTION_TO_DB_IS: ${connection.connected}');
  }

  @override
  Future<bool> addItem(ItemDataModel model) async {
    try {
      await connection.execute(
          '''insert into items (name, startDateTime, userId, isComplete) 
          values (:name,:startDateTime, :userId, :isComplete)''',
          {
            'name': model.name,
            'startDateTime': null,
            //  DateTime.now().toIso8601String(),
            'userId': model.userId,
            'isComplete': 0
          });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<ItemDataModel>> getData(String userId) async {
    final res = await connection.execute(
      'select * from items where userId=:userId',
      {'userId': userId},
    );
    final items = <ItemDataModel>[];
    for (final e in res.rows) {
      items.add(ItemDataModel.fromJson(e.assoc()));
    }
    return items;
  }

  @override
  Future<bool> removeItem(String id) async {
    try {
      await connection.execute('delete from items where id=:id', {'id': id});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> completeItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await connection.execute(
        'update items set isComplete=1 where id=:id and userId=:userId  ',
        {'userId': userId, 'id': itemId},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createUser(RegisterModel registerModel) async {
    final res = await connection.execute(
      'select count(*) from users where login=:log ',
      {
        'log': registerModel.login,
      },
    );
    final count = int.parse(res.rows.first.assoc().values.first ?? '0');
    if (count == 0) {
      await connection.execute(
        'insert into users (login, password) values(:login, :password)',
        {
          'login': registerModel.login,
          'password': registerModel.password,
        },
      );
    }
    return count == 0;
  }

  @override
  Future<bool> isExistUser(RegisterModel registerModel) async {
    final res = await connection.execute(
      'select count(*) from users where login=:log and password=:pass ',
      {'log': registerModel.login, 'pass': registerModel.password},
    );
    final count = int.parse(res.rows.first.assoc().values.first ?? '0');
    return count != 0;
  }

  @override
  Future<ItemDataModel?> getItemById({
    required String userId,
    required String itemId,
  }) async {
    try {
      final res = await connection.execute(
        'select * from items where id=:id and userId=:userId',
        {'userId': userId, 'id': itemId},
      );
      return ItemDataModel.fromJson(res.rows.first.assoc());
    } catch (e) {
      return null;
    }
  }
}
