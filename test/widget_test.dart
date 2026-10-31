import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeeshan_daily_life_style/data/fields.dart';
import 'package:zeeshan_daily_life_style/screens/field_input.dart';

Widget _testApp(FieldDef field) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFC9A65A),
        brightness: Brightness.dark,
      ),
    ),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FieldInput(
              field: field,
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('single-line fields stay compact and show their label', (tester) async {
    await tester.pumpWidget(
      _testApp(const FieldDef('p1', 'Priority 1', FieldType.text)),
    );

    final input = find.byType(TextFormField);
    expect(input, findsOneWidget);
    expect(tester.getSize(input).height, lessThanOrEqualTo(70));
    expect(find.text('Priority 1'), findsOneWidget);
  });

  testWidgets('multiline fields have a bounded writing area', (tester) async {
    await tester.pumpWidget(
      _testApp(const FieldDef('notes', 'Daily notes', FieldType.multiline)),
    );

    final input = find.byType(TextFormField);
    expect(input, findsOneWidget);
    expect(tester.getSize(input).height, inInclusiveRange(130, 145));
    expect(find.text('Daily notes'), findsOneWidget);
  });

  testWidgets('unanswered rating fields are not presented as a saved score', (tester) async {
    await tester.pumpWidget(
      _testApp(const FieldDef('rating', 'Sleep quality', FieldType.rating)),
    );

    expect(find.text('Sleep quality'), findsOneWidget);
    expect(find.text('Not rated'), findsOneWidget);
  });

  testWidgets('multi-choice field reports selected options', (tester) async {
    List<String> latestSelection = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FieldInput(
            field: const FieldDef(
              'places',
              'Places',
              FieldType.multiChoice,
              options: ['Home', 'Office'],
            ),
            value: const <String>[],
            onChanged: (value) {
              latestSelection = List<String>.from(value as List);
            },
          ),
        ),
      ),
    );

    expect(find.text('Places'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pump();

    expect(latestSelection, ['Home']);
  });

  testWidgets('all supported field types build their visible controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                FieldInput(
                  field: const FieldDef('plain', 'Plain text', FieldType.text),
                  value: null,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef('long', 'Long text', FieldType.multiline),
                  value: null,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef('count', 'Count', FieldType.number),
                  value: null,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef('rating', 'Rating', FieldType.rating),
                  value: 5,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef('enabled', 'Enabled', FieldType.toggle),
                  value: false,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef(
                    'choice',
                    'Choice',
                    FieldType.choice,
                    options: ['One', 'Two'],
                  ),
                  value: null,
                  onChanged: (_) {},
                ),
                FieldInput(
                  field: const FieldDef(
                    'multiple',
                    'Multiple choice',
                    FieldType.multiChoice,
                    options: ['A', 'B'],
                  ),
                  value: const <String>[],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(2));
    expect(find.text('Plain text'), findsOneWidget);
    expect(find.text('Long text'), findsOneWidget);
    expect(find.text('Multiple choice'), findsOneWidget);
  });
}
