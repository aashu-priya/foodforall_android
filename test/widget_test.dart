import 'package:flutter_test/flutter_test.dart';

import 'package:food_for_all/main.dart';

void main() {
  testWidgets('HomePage renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodForAllApp());

    // Verify that our app title appears
    expect(find.text('Food For All'), findsOneWidget);
    expect(find.text('Welcome to Food For All!'), findsOneWidget);
  });
}
