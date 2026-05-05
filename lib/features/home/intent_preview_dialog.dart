import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:murmur/core/murmur_theme.dart';

class IntentPreviewDialog extends StatelessWidget {
  final String title;
  final String summary;
  final VoidCallback onConfirm;

  const IntentPreviewDialog({
    super.key,
    required this.title,
    required this.summary,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: AlertDialog(
        backgroundColor: MurmurTheme.surface.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        title: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AGENTIC INTENT PREVIEW',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              summary,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MurmurTheme.accent.withOpacity(0.1),
              foregroundColor: MurmurTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('PROCEED'),
          ),
        ],
      ),
    );
  }
}
