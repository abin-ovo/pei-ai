import 'package:flutter/material.dart';

void showMewToast(BuildContext context, String message, {bool success = true}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      top: MediaQuery.of(ctx).padding.top + 16,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: _ToastBanner(
          message: message,
          success: success,
          onDismiss: () => entry.remove(),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 2), () {
    if (entry.mounted) entry.remove();
  });
}

class _ToastBanner extends StatefulWidget {
  const _ToastBanner({
    required this.message,
    required this.success,
    required this.onDismiss,
  });

  final String message;
  final bool success;
  final VoidCallback onDismiss;

  @override
  State<_ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<_ToastBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.success
              ? const Color(0xFFD1FAE5)
              : const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x15000000), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(
              widget.success ? Icons.check_circle : Icons.error,
              color: widget.success
                  ? const Color(0xFF059669)
                  : const Color(0xFFDC2626),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.success
                      ? const Color(0xFF065F46)
                      : const Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
