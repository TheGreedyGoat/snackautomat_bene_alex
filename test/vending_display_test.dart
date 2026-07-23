import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/vending_display.dart';

void main() {
  testWidgets('taps on the content are blocked while the door is closed', (
    WidgetTester tester,
  ) async {
    int tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VendingDisplay(
            child: GestureDetector(
              onTap: () => tapCount++,
              child: const SizedBox(
                width: 300,
                height: 300,
                child: Center(child: Text('target')),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('target'));
    await tester.pump();
    expect(tapCount, 0);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(const Duration(milliseconds: 120));

    await tester.tap(find.text('target'));
    await tester.pump();
    expect(tapCount, 1);
  });
}
