import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/design_system/design_system.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
    );

void main() {
  group('CustomText', () {
    testWidgets('cada variante usa o estilo do tema', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              CustomText.headline('h'),
              CustomText.title('t'),
              CustomText('b'),
              CustomText.caption('c'),
            ],
          ),
        ),
      );

      final textTheme = AppTheme.dark.textTheme;
      TextStyle styleOf(String text) =>
          tester.widget<Text>(find.text(text)).style!;

      expect(styleOf('h').fontSize, textTheme.headlineLarge!.fontSize);
      expect(styleOf('t').fontSize, textTheme.titleLarge!.fontSize);
      expect(styleOf('b').fontSize, textTheme.bodyMedium!.fontSize);
      expect(styleOf('c').fontSize, textTheme.bodySmall!.fontSize);
      expect(styleOf('b').color, AppColors.textPrimary);
      expect(styleOf('b').fontFamily, AppTypography.fontFamily);
    });

    testWidgets('parâmetros sobrescrevem só o que foi passado', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CustomText.title(
            'x',
            color: AppColors.primary,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

      final style = tester.widget<Text>(find.text('x')).style!;
      expect(style.color, AppColors.primary);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.fontSize, AppTheme.dark.textTheme.titleLarge!.fontSize);
    });
  });

  group('AppPasswordField', () {
    bool isObscured(WidgetTester tester) =>
        tester.widget<EditableText>(find.byType(EditableText)).obscureText;

    testWidgets('começa oculto e alterna ao tocar no ícone', (tester) async {
      await tester.pumpWidget(_wrap(const AppPasswordField()));

      expect(isObscured(tester), isTrue);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(isObscured(tester), isFalse);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(isObscured(tester), isTrue);
    });
  });

  group('AppButton', () {
    testWidgets('em loading mostra indicador e ignora toques', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppButton(
            label: 'Entrar', isLoading: true, onPressed: () => taps++)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Entrar'), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 0);
    });

    testWidgets('fora de loading executa a ação', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Entrar', onPressed: () => taps++)),
      );

      await tester.tap(find.text('Entrar'));
      expect(taps, 1);
    });
  });
}
