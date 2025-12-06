import 'package:flutter/material.dart';
import 'deck_item.dart';

class SideDeck extends StatelessWidget {
  final List<DeckItem> items;
  final double width;
  final EdgeInsets padding;

  const SideDeck({
    super.key,
    required this.items,
    this.width = 200,
    this.padding = const EdgeInsets.symmetric(vertical: 0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: SafeArea(
        left: false,
        child: Padding(
          padding: padding,
          child: Column(
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

