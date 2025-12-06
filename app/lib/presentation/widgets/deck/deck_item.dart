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
  final String angleText;
  final String fractionText;
  final String sarthakFractionText;

  const DeckResultItem({
    super.key,
    required this.angleText,
    required this.fractionText,
    required this.sarthakFractionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;
    final labelFontSize = shortestSide * 0.05;
    final valueFontSize = shortestSide * 0.05;

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
            style: theme.textTheme.titleMedium?.copyWith(fontSize: valueFontSize),
          ),
          Text(
            'Fraction:',
            style: theme.textTheme.labelLarge?.copyWith(fontSize: labelFontSize),
          ),
          Text(
            fractionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: valueFontSize),
          ),
          Text(
            'Sarthak:',
            style: theme.textTheme.titleSmall?.copyWith(fontSize: labelFontSize),
          ),
          Text(
            sarthakFractionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: valueFontSize),
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
    final clampedFraction = fraction.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight;
          final ballDiameter = (availableWidth * 0.4).clamp(0.0, availableHeight * 0.8);
          final overlap = ballDiameter * clampedFraction;
          final totalWidth = (ballDiameter * 2) - overlap;

          return Center(
          child: SizedBox(
            width: totalWidth,
            height: availableHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
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
                  left: ballDiameter - overlap,
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

