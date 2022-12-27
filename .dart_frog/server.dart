// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../routes/index.dart' as index;
import '../routes/user_service/user_service.dart' as user_service_user_service;
import '../routes/api/get_data.dart' as api_get_data;

import '../routes/user_service/_middleware.dart' as user_service_middleware;
import '../routes/api/_middleware.dart' as api_middleware;
import '../data/mysql_db.dart';

void main() => hotReload(createServer);

Future<HttpServer> createServer() {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse('8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  MySqlDataSourse();
  return serve(handler, ip, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/api', (r) => buildApiHandler()(r))
    ..mount('/user_service', (r) => buildUserServiceHandler()(r))
    ..mount('/', (r) => buildHandler()(r));
  return pipeline.addHandler(router);
}

Handler buildApiHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware);
  final router = Router()
    ..all('/complete', api_get_data.onRequest)
    ..all('/add', api_get_data.onRequest)
    ..all('/remove', api_get_data.onRequest)
    ..all('/data', api_get_data.onRequest);
  return pipeline.addHandler(router);
}

Handler buildUserServiceHandler() {
  final pipeline =
      const Pipeline().addMiddleware(user_service_middleware.middleware);
  final router = Router()
    ..all('/register', user_service_user_service.onRequest)
    ..all('/auth', user_service_user_service.onRequest);
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  const pipeline = Pipeline();
  final router = Router()..all('/', index.onRequest);
  return pipeline.addHandler(router);
}
