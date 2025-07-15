import 'package:flutter_test/flutter_test.dart';
import 'package:ecroft_fresh/main.dart';

void main() {
  testWidgets('MyApp renders SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Expect splash screen welcome text
    expect(find.text('Welcome to eCroft Fresh'), findsOneWidget);
  });
}
