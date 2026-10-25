import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mewmory/core/theme/app_colors.dart';
import 'package:mewmory/core/widgets/gradient_scaffold.dart';
import 'package:mewmory/core/widgets/mew_bottom_nav.dart';
import 'package:mewmory/providers/app_state.dart';
import '../home/home_screen.dart';
import '../lab/lab_screen.dart';
import '../memory/memory_screen.dart';
import '../profile/profile_screen.dart';
import '../coffee/coffee_log_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return GradientScaffold(
          extendBody: true,
          body: IndexedStack(
            index: state.navIndex,
            children: const [
              HomeScreen(),
              LabScreen(),
              MemoryScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: MewBottomNav(
            currentIndex: state.navIndex,
            onTap: state.setNavIndex,
            onCenterTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoffeeLogScreen()),
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🐱', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'MEWMORY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
