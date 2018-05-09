// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tip_calc/main.dart';

void main() {
  testWidgets('Tip Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new TipCalculator());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    expect(find.text('15%'), findsOneWidget);
    expect(find.text('18%'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);

    expect(find.text("0.00"), findsNWidgets(4));

    await tester.tap(find.byKey(new Key("1")));
    await tester.tap(find.byKey(new Key("2")));
    await tester.tap(find.byKey(new Key("3")));
    await tester.tap(find.byKey(new Key("4")));
    await tester.tap(find.byKey(new Key("5")));
    await tester.tap(find.byKey(new Key("6")));
    await tester.tap(find.byKey(new Key("7")));
    await tester.tap(find.byKey(new Key("8")));
    await tester.tap(find.byKey(new Key("9")));
    await tester.tap(find.byKey(new Key("0")));
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.tap(find.byIcon(Icons.cancel));

    await tester.drag(find.byKey(new Key("FriendsSlider")), new Offset(100.0, 0.0));
    await tester.drag(find.byKey(new Key("FriendsSlider")), new Offset(200.0, 0.0));
    await tester.drag(find.byKey(new Key("FriendsSlider")), new Offset(300.0, 0.0));

    await tester.pump();

  });
}
