import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = Theme.of(context).colorScheme.primary.withValues(alpha: 0.6);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Theme.of(context).colorScheme.primary : null,
                shadows: isDark
                    ? [
                        Shadow(
                          color: glow,
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
