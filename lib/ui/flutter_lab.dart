
import 'package:flutter/material.dart';

import '../domain/models/startup_destination.dart';
import 'intro/intro_screen.dart';

class FlutterLabApp extends StatelessWidget {
  const FlutterLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D1B2A)),
      ),
      home: IntroScreen(
        onLogoReady: WidgetsBinding.instance.allowFirstFrame,
        destinationBuilder: (destination) => switch (destination) {
          StartupDestination.onboarding =>
          const _PlaceholderScreen(title: 'Onboarding'),
          StartupDestination.home => const _PlaceholderScreen(title: 'Home'),
        },
      ),
    );
  }
}


class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}