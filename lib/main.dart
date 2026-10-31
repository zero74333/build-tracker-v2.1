import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZeeshanLifeStyleApp());
}

class ZeeshanLifeStyleApp extends StatelessWidget {
  const ZeeshanLifeStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFC9A65A);
    const background = Color(0xFF101719);
    const surface = Color(0xFF192226);
    const fieldSurface = Color(0xFF202B30);

    final scheme = ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
      surface: surface,
    );

    const outline = Color(0xFF39474B);
    const radius = BorderRadius.all(Radius.circular(14));

    return MaterialApp(
      title: 'Zeeshan Daily Life Style',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: scheme,
        scaffoldBackgroundColor: background,
        visualDensity: VisualDensity.standard,
        appBarTheme: const AppBarThemeData(
          backgroundColor: background,
          foregroundColor: Color(0xFFF1EBDD),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: fieldSurface,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          border: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: outline),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: outline),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: gold, width: 1.6),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: Color(0xFFE28B82)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: Color(0xFFE28B82), width: 1.6),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: gold.withValues(alpha: 0.20),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontWeight: FontWeight.w700, fontSize: 12);
            }
            return const TextStyle(fontSize: 12);
          }),
        ),
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.onDrag,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          iconColor: gold,
          collapsedIconColor: Color(0xFFB9B7AE),
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
