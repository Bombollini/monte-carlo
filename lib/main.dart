import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/theme.dart';
import 'ui/screens/setup_screen.dart';

void main() {
  runApp(const ProviderScope(child: BlackjackApp()));
}

class BlackjackApp extends StatelessWidget {
  const BlackjackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monte Carlo',
      theme: AppTheme.darkTheme,
      home: const SetupScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
