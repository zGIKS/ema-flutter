import 'package:flutter_test/flutter_test.dart';

import 'package:ema/main.dart';

void main() {
  testWidgets('Identity home smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home shell renders.
    expect(find.text('Ema'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
