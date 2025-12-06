import 'package:flutter/material.dart';
import 'deck_item.dart';

class BottomDeck extends StatelessWidget {
  final List<DeckItem> items;
  final double height;
  final EdgeInsets padding;

  const BottomDeck({
    super.key,
    required this.items,
    this.height = 72,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items
                .map((item) => Expanded(
                      child: item,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

