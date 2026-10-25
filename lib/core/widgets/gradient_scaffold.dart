import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.gradient = AppColors.gradientHome,
    this.extendBody = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Color> gradient;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
          ),
        ),
        child: SafeArea(
          bottom: bottomNavigationBar == null,
          child: body,
        ),
      ),
    );
  }
}
