import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:snackautomat_bene_alex/test_app/temp_test_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await _configureDesktopWindow();
  }

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  runTestApp();
}

// min height = 3/4 of the desktop height
// min width = about 1/3 of the desktop width (we use / 2.5)
// TODO: maybe find a better way so it always looks ok on every screen
Future<void> _configureDesktopWindow() async {
  final screen = await getCurrentScreen();
  if (screen == null) return;

  final desktop = screen.visibleFrame;
  setWindowMinSize(
    Size(desktop.width / 2.5, desktop.height * 3 / 4),
  );
}
