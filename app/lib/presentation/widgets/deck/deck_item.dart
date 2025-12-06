import 'package:flutter/material.dart';

abstract class DeckItem extends StatelessWidget {
  const DeckItem({super.key});
}

class DeckActionItem extends DeckItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool enabled;

  const DeckActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;
    final fontSize = shortestSide * 0.02;
    final iconSize = shortestSide * 0.035;
    final effectiveColor = enabled
        ? (iconColor ?? theme.colorScheme.onSurface)
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: effectiveColor, size: iconSize),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: effectiveColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeckResultItem extends DeckItem {
  final double? angleDegrees;
  final double fraction;
  final double sarthakFraction;

  const DeckResultItem({
    super.key,
    required this.angleDegrees,
    required this.fraction,
    required this.sarthakFraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;
    final labelFontSize = shortestSide * 0.05;
    final valueFontSize = shortestSide * 0.05;

    final angleText = angleDegrees != null ? '${angleDegrees!.toStringAsFixed(2)}°' : '-';
    final fractionText = '${(fraction.abs() * 100).toStringAsFixed(2)}%';
    final sarthakFractionText = '${(sarthakFraction.abs() * 100).toStringAsFixed(2)}%';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Angle:',
            style: theme.textTheme.titleSmall?.copyWith(fontSize: labelFontSize),
          ),
          Text(
            angleText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Fraction:',
            style: theme.textTheme.labelLarge?.copyWith(fontSize: labelFontSize),
          ),
          Text(
            fractionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Sarthak Fraction:',
            style: theme.textTheme.titleSmall?.copyWith(fontSize: labelFontSize),
          ),
          Text(
            sarthakFractionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DeckOverlapItem extends DeckItem {
  final double fraction;

  const DeckOverlapItem({
    super.key,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final clampedFraction = fraction.clamp(-1.0, 1.0);
    final absFraction = clampedFraction.abs();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight;
          final ballDiameter = (availableWidth * 0.4).clamp(0.0, availableHeight * 0.8);
          final overlap = ballDiameter * absFraction;
          final totalWidth = (ballDiameter * 2) - overlap;

          final objectBallLeft = clampedFraction > 0 ? ballDiameter - overlap : 0.0;
          final cueBallLeft = clampedFraction > 0 ? 0.0 : ballDiameter - overlap;

          return Center(
            child: SizedBox(
              width: totalWidth,
              height: availableHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: objectBallLeft,
                    child: Container(
                      width: ballDiameter,
                      height: ballDiameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: cueBallLeft,
                    child: Container(
                      width: ballDiameter,
                      height: ballDiameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.7),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

