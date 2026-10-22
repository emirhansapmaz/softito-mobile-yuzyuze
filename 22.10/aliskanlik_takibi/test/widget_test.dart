import 'package:flutter_test/flutter_test.dart';
import 'package:aliskanlik_takibi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AliskanlikTakibiApp());
    expect(find.byType(AliskanlikTakibiApp), findsOneWidget);
  });
}
