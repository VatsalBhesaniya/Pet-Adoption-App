import 'package:adopt_pets/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('app test', () {
    testWidgets('UI flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));

      await tester.tap(find.byType(Container).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      navigator.pop();
      await tester.pumpAndSettle();

      navigator.pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.nightlight_round).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.light_mode_rounded).first);
      await tester.pumpAndSettle();

      navigator.pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.history_rounded).first);
      await tester.pumpAndSettle();

      navigator.pop();
      await tester.pumpAndSettle();
    });
  });
}
