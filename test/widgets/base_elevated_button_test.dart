import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'base_elevated_button_test.mocks.dart';

class OnPressedHandler {
  void onPressed() {}
}

@GenerateMocks([OnPressedHandler])
void main() {
  group('BaseElevatedButton', () {
    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      final mockOnPressedHandler = MockOnPressedHandler();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseElevatedButton(
              text: 'Elevated Button',
              onPressed: mockOnPressedHandler.onPressed
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pump();

      verify(mockOnPressedHandler.onPressed()).called(1);
    });

    testWidgets('does not call onPressed when button is disabled', (WidgetTester tester) async {
      final mockOnPressedHandler = MockOnPressedHandler();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseElevatedButton(
              text: 'Disabled Button',
              onPressed: mockOnPressedHandler.onPressed,
              isDisabled: true
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pump();

      verifyNever(mockOnPressedHandler.onPressed());
    });
  });
}
