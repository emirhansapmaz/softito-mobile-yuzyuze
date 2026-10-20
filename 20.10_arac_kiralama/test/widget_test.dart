import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sem_auto/main.dart';
import 'package:sem_auto/providers/auth_provider.dart';
import 'package:sem_auto/providers/theme_provider.dart';
import 'package:sem_auto/providers/vehicle_provider.dart';
import 'package:sem_auto/widgets/sem_logo.dart';

void main() {
  testWidgets('SemAutoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ],
        child: const SemAutoApp(),
      ),
    );

    // Initial splash frame
    expect(find.byType(SemLogo), findsWidgets);

    // Advance timer past splash duration
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verify Login Screen loaded
    expect(find.byType(SemLogo), findsWidgets);
  });
}
