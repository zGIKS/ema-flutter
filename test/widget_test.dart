import 'package:flutter_test/flutter_test.dart';

import 'package:ema/main.dart';

void main() {
  testWidgets('Hello World smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows 'Hello World'.
    expect(find.text('Hello World'), findsOneWidget);
  });
}
