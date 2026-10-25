import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MewCard extends StatelessWidget {
  const MewCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.white,
    this.radius = 20,
    this.onTap,
    this.border,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double radius;
  final VoidCallback? onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
