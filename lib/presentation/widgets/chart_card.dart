import 'package:flutter/material.dart';

import 'glass_card.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = Theme.of(context).colorScheme.primary.withValues(alpha: 0.6);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Theme.of(context).colorScheme.primary : null,
                  shadows: isDark
                      ? [
                          Shadow(
                            color: glow,
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}
