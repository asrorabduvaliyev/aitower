import 'package:flutter/material.dart';
import 'l10n/strings.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Lang.load();
  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
        valueListenable: Lang.current,
        builder: (_, __, ___) => MaterialApp(
          title: tr('app_title'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: const Color(0xFF0D3B66), useMaterial3: true),
          home: const HomeScreen(),
        ),
      );
}
