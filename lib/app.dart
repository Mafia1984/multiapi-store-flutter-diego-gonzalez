
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/providers.dart';
import 'features/home/home_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'MultiAPI – Diego Gonzalez',
      themeMode: themeMode,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
