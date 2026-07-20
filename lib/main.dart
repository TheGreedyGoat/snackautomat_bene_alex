import 'dart:io';
// import 'package:snackautomat_bene_alex/back_layer/database_service.dart';
import 'package:snackautomat_bene_alex/test_app/temp_test_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  // await DataBaseService.instance.removeDatabase();
  // print('deleted');
  runTestApp();
}
