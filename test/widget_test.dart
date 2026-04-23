import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('App carga', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Super App'), findsOneWidget);
  });
}