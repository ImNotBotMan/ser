// ignore_for_file: omit_local_variable_types

import 'package:dart_frog/dart_frog.dart';

import '../../data/mysql_db.dart';
import '../../models/data/list_data_model.dart';
import '../../models/error_model.dart';

Future<Response> onRequest(RequestContext context) async {
  late Response response;
  switch (context.request.method) {
    case HttpMethod.get:
      response = await getData(context);
      break;
    case HttpMethod.put:
      response = await completeItem(context);
      break;
    case HttpMethod.post:
      response = await addItem(context);
      break;
    case HttpMethod.delete:
      response = await removeItem(context);
      break;
    default:
  }

  return response;
}

Future<Response> removeItem(RequestContext context) async {
  final db = context.read<IDataSourse>();
  final String body = await context.request.body();
  final bool isSucces = await db.removeItem(itemDatafromJson(body).id ?? '');

  return Response.json(
    statusCode: isSucces ? 200 : 400,
    body: isSucces ? {'isSucces': isSucces} : ErrorModel.noItem().toJson(),
  );
}

Future<Response> addItem(RequestContext context) async {
  final db = context.read<IDataSourse>();
  final String body = await context.request.body();
  final bool isSucces = await db.addItem(itemDatafromJson(body));

  return Response.json(
    statusCode: isSucces ? 200 : 400,
    body: isSucces ? {'isSucces': isSucces} : ErrorModel.noItem().toJson(),
  );
}

Future<Response> completeItem(RequestContext context) async {
  final db = context.read<IDataSourse>();
  final String body = await context.request.body();
  final request = itemDatafromJson(body);

  final bool isSucces = await db.completeItem(
    userId: request.userId ?? '0',
    itemId: request.id ?? '0',
  );
  late ItemDataModel? item;
  if (isSucces) {
    item = await db.getItemById(
      userId: request.userId ?? '0',
      itemId: request.id ?? '0',
    );
  }

  return Response.json(
    statusCode: isSucces && item != null ? 200 : 400,
    body:
        isSucces && item != null ? item.toJson() : ErrorModel.noItem().toJson(),
  );
}

Future<Response> getData(RequestContext context) async {
  final db = context.read<IDataSourse>();
  final String body = await context.request.body();
  final items = await db.getData(itemDatafromJson(body).userId ?? '0');

  return Response.json(
    body: items,
  );
}
