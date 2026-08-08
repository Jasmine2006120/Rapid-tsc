import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class GreenWaveApp extends StatelessWidget {
  const GreenWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenWave AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const GreenWaveHome(),
    );
  }
}

class GreenWaveHome extends StatelessWidget {
  const GreenWaveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GreenWave AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'GreenWave AI',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}