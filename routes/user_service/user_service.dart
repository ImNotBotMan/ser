// ignore_for_file: omit_local_variable_types

import 'package:dart_frog/dart_frog.dart';

import '../../data/mysql_db.dart';
import '../../models/error_model.dart';
import '../../models/data/list_data_model.dart';
import '../../models/user/login.dart';

Future<Response> onRequest(RequestContext context) async {
  late Response response;
  switch (context.request.method) {
    case HttpMethod.get:
      response = await onAuthRequest(context);
      break;
    case HttpMethod.post:
      response = await saveUser(context);
      break;

    // ignore: no_default_cases
    default:
  }
  return response;
}

Future<Response> onAuthRequest(RequestContext context) async {
  final IDataSourse db = context.read<IDataSourse>();
  final String request = await context.request.body();
  final bool isExists = await db.isExistUser(registerModelFromJson(request));
  if (isExists) {
    return Response(body: {'isAuth': isExists}.toString());
  } else {
    return Response.json(statusCode: 400, body: ErrorModel.notAuth().toJson());
  }
}

Future<Response> saveUser(RequestContext context) async {
  final Request request = context.request;
  final IDataSourse db = context.read<IDataSourse>();
  final String body = await request.body();
  final RegisterModel registerModel = registerModelFromJson(body);
  final bool isRegistred = await db.createUser(registerModel);
  return Response.json(
    statusCode: isRegistred ? 200 : 400,
    body: isRegistred ? {'isAuth': isRegistred} : ErrorModel.notAuth(),
  );
}
