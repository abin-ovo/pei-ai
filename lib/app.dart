import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/shell/main_shell.dart';

class MewmoryApp extends StatelessWidget {
  const MewmoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'MEWMORY · 猫咪 AI 陪伴',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _AppRoot(),
      ),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const SplashScreen();
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!state.loaded) {
          return const SplashScreen();
        }
        return const MainShell();
      },
    );
  }
}
