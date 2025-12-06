import 'package:flutter/material.dart';
import 'deck_item.dart';

class ResetDeckItem extends DeckActionItem {
  const ResetDeckItem({
    super.key,
    required super.onTap,
    super.enabled = true,
  }) : super(
          icon: Icons.refresh,
          label: 'Reset',
        );
}

