import 'package:flutter/material.dart';
import 'deck_item.dart';

class SideDeck extends StatefulWidget {
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
  State<SideDeck> createState() => _SideDeckState();
}

class _SideDeckState extends State<SideDeck> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: widget.width,
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
          padding: widget.padding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < widget.items.length - 1; i++) widget.items[i],
                        if (widget.items.isNotEmpty)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight * 0.3,
                            ),
                            child: widget.items.last,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

