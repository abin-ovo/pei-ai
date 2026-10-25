import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';

Future<void> showMemoryConfirmDialog(
  BuildContext context,
  AppState state,
) async {
  final candidate = state.pendingMemoryCandidate;
  if (candidate == null) return;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Text('🐱', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Text('猫咪想记住'),
        ],
      ),
      content: Text(
        candidate.description,
        style: const TextStyle(fontSize: 15, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () {
            state.dismissMemoryCandidate();
            Navigator.pop(ctx);
          },
          child: const Text('暂时不用', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () async {
            await state.confirmMemoryCandidate();
            if (ctx.mounted) Navigator.pop(ctx);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40),
          ),
          child: const Text('记住吧 ❤️'),
        ),
      ],
    ),
  );
}
