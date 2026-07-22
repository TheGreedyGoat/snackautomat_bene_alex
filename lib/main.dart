import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:snackautomat_bene_alex/test_app/temp_test_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

// fixed window size — not resizable (tweak if needed)
const Size _windowSize = Size(1200, 1300);

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

Future<void> _configureDesktopWindow() async {
  final screen = await getCurrentScreen();
  if (screen == null) return;

  final desktop = screen.visibleFrame;
  // never larger than the screen, but still locked (min == max)
  final width = math.min(_windowSize.width, desktop.width);
  final height = math.min(_windowSize.height, desktop.height);
  final left = desktop.left + (desktop.width - width) / 2;
  final top = desktop.top + (desktop.height - height) / 2;
  final size = Size(width, height);

  setWindowFrame(Rect.fromLTWH(left, top, width, height));
  setWindowMinSize(size);
  setWindowMaxSize(size);
}
