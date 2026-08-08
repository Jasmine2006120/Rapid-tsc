import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/vehicle/app_vehicle.dart';
import 'screens/dashboard/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GreenWaveApp());
}

class GreenWaveApp extends StatelessWidget {
  const GreenWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    const vehicle = AppVehicle(
      vehicleId: 'GW-EM-001',
      vehicleType: 'Emergency Ambulance',
      driverName: 'Emergency Driver',
      registrationNumber: 'GW-AMB-001',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenWave AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(
        vehicle: vehicle,
      ),
    );
  }
}