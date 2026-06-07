import 'package:flutter_test/flutter_test.dart';

import 'package:ema/main.dart';

void main() {
  testWidgets('Identity smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the identity registration screen renders.
    expect(find.text('Register New Person'), findsOneWidget);
  });
}
