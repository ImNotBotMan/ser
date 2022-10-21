import 'package:dart_frog/dart_frog.dart';

import '../../data/mysql_db.dart';

Handler middleware(Handler handler) {
  return handler.use(dataSourceProvider());
}

Middleware dataSourceProvider() {
  return provider<IDataSourse>((context) => MySqlDataSourse());
}
