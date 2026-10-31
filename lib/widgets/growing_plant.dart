import 'package:flutter/material.dart';

class GrowingPlant extends StatelessWidget {
  const GrowingPlant({
    super.key,
    required this.progress,
  });

  final double progress;

  String get _plantEmoji {
    if (progress >= 1.0) return '🌻';
    if (progress >= 0.4) return '🌿';
    return '🌱';
  }

  String get _stageLabel {
    if (progress >= 1.0) return 'Fully grown';
    if (progress >= 0.4) return 'Growing strong';
    if (progress >= 0.01) return 'Taking root';
    return 'Seed ready';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scale = 0.35 + (progress * 0.65);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: colors.surfaceContainerHighest,
                  color: colors.primary,
                  semanticsLabel: 'Focus session progress',
                  semanticsValue: '${(progress * 100).round()}%',
                ),
              ),
              AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _plantEmoji,
                    key: ValueKey(_plantEmoji),
                    style: const TextStyle(fontSize: 96),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _stageLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.primary,
              ),
        ),
      ],
    );
  }
}