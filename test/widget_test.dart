import 'package:flutter_test/flutter_test.dart';
import 'package:rolla_fitness_app_demo/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RollaFitnessApp());

    // Verify that the app title is present
    expect(find.text('Health Score'), findsOneWidget);
  });
}
