import 'package:flutter_test/flutter_test.dart';
import 'package:resolve/main.dart';

void main() {
  testWidgets('App opens on the login screen', (WidgetTester tester) async {
    // ---------- Build the app ----------
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // ---------- Check the first screen ----------
    expect(find.text('Welcome Back, Athlete'), findsOneWidget);
    expect(find.text('SIGN IN'), findsOneWidget);
  });
}
