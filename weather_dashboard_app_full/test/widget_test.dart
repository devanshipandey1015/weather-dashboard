import 'package:flutter_test/flutter_test.dart';
import 'package:weather_dashboard_app_full/main.dart';

void main() {
  testWidgets('Weather app renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherDashboardApp());
    expect(find.text('Weather Dashboard'), findsWidgets);
  });
}
