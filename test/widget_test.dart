// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cinevault/app.dart';

void main() {
  testWidgets('CineVault app smoke test', (WidgetTester tester) async {
    // App ko build karein aur frame trigger karein.
    await tester.pumpWidget(const CineVaultApp());

    // Check karein ke CineVault ka title screen par nazar aa raha hai.
    // Ye confirm karega ke app sahi initialize hui hai.
    expect(find.text('CineVault'), findsWidgets);
  });
}