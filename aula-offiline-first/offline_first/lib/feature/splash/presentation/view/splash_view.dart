import 'package:flutter/material.dart';

import 'package:offline_first/core/constant/gen/assets.gen.dart';
import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/services/navigation_service/i_navigation_service.dart';
import 'package:offline_first/feature/home/presentation/view/home_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      await sl<INavigationService>().pushReplacement(
        context,
        const HomeView(),
      );
    });
    return Scaffold(
      body: Center(
        child: Assets.splashAnimation.lottie(
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
