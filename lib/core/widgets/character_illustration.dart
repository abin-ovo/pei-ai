import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Stylized placeholder matching MEWMORY character aesthetic
class CharacterIllustration extends StatelessWidget {
  const CharacterIllustration({
    super.key,
    this.variant = CharacterVariant.home,
    this.height = 160,
  });

  final CharacterVariant variant;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: height * 1.4,
            height: height * 0.7,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPale.withValues(alpha: 0.6),
                  AppColors.lavender.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(height * 0.35),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _GirlAvatar(size: height * 0.55, variant: variant),
              const SizedBox(width: 8),
              _CatAvatar(size: height * 0.45, variant: variant),
            ],
          ),
        ],
      ),
    );
  }
}

enum CharacterVariant { home, coffee, sleep, memory, lab, report }

class _GirlAvatar extends StatelessWidget {
  const _GirlAvatar({required this.size, required this.variant});
  final double size;
  final CharacterVariant variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE1BEE7), Color(0xFFCE93D8)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // hair
              Positioned(
                top: size * 0.05,
                child: Container(
                  width: size * 0.85,
                  height: size * 0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB39DDB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              // sunglasses
              Positioned(
                top: size * 0.35,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _lens(size * 0.18),
                    SizedBox(width: size * 0.04),
                    _lens(size * 0.18),
                  ],
                ),
              ),
              if (variant == CharacterVariant.coffee)
                Positioned(
                  bottom: size * 0.05,
                  child: const Text('☕', style: TextStyle(fontSize: 20)),
                ),
              if (variant == CharacterVariant.sleep)
                Positioned(
                  top: size * 0.1,
                  right: size * 0.05,
                  child: const Text('💤', style: TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lens(double s) => Container(
        width: s,
        height: s * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFF424242),
          borderRadius: BorderRadius.circular(s),
        ),
      );
}

class _CatAvatar extends StatelessWidget {
  const _CatAvatar({required this.size, required this.variant});
  final double size;
  final CharacterVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x15000000), blurRadius: 8),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ears
          Positioned(
            top: size * 0.02,
            left: size * 0.1,
            child: _ear(size * 0.22),
          ),
          Positioned(
            top: size * 0.02,
            right: size * 0.1,
            child: _ear(size * 0.22),
          ),
          // face
          Text(
            variant == CharacterVariant.sleep ? '😴' : '😾',
            style: TextStyle(fontSize: size * 0.45),
          ),
          if (variant == CharacterVariant.memory)
            Positioned(
              bottom: 2,
              child: const Text('❤️', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _ear(double s) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryLight),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      );
}
