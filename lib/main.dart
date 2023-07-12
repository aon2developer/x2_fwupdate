import 'package:flutter/material.dart';
import 'package:x2_fwupdate/update_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 0, 0, 0),
      brightness: Brightness.dark,
    ),
    // TODO: configure text colors
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 58),
      titleMedium: TextStyle(
        color: Colors.grey,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey,
      ),
    ));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: UpdateScreen(),
      ),
    );
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
