import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

const _emojis = ['😢', '😕', '😐', '🙂', '😊'];
const _labels = ['很差', '较差', '一般', '不错', '很好'];

class EmojiRating extends StatelessWidget {
  const EmojiRating({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final selected = selectedIndex == i;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryPale
                      : AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _emojis[i],
                  style: TextStyle(fontSize: selected ? 26 : 22),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textHint,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
