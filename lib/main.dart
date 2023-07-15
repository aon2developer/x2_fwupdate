import 'package:flutter/material.dart';
import 'package:x2_fwupdate/screens/device_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 69, 60, 49),
    brightness: Brightness.dark,
  ),
  // TODO: configure text colors
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 58,
    ),
    titleMedium: TextStyle(
      fontSize: 38,
    ),
    titleSmall: TextStyle(
      fontSize: 24,
    ),
    bodyLarge: TextStyle(
      color: Colors.grey,
      fontSize: 22,
    ),
    bodyMedium: TextStyle(
      color: Colors.grey,
      fontSize: 20,
    ),
  ),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: DeviceScreen(),
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
