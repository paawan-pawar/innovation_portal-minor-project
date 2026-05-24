import 'package:flutter_test/flutter_test.dart';
import 'package:minor/main.dart';

void main() {
  testWidgets('Innovation portal app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InnovationPortalApp());
    // Verify the splash screen appears
    expect(find.text('INDICATORS PORTAL'), findsOneWidget);
  });
}
