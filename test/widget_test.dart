import 'package:flutter_test/flutter_test.dart';
import 'package:mewmory/app.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const MewmoryApp());
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('早安呀 🌸'), findsOneWidget);
  });
}
