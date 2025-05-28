import 'package:flutter/material.dart';

import 'package:offline_first/core/constant/app_constants.dart';
import 'package:offline_first/feature/splash/presentation/view/splash_view.dart';

class OfflineFirstDemo extends StatelessWidget {
  const OfflineFirstDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
