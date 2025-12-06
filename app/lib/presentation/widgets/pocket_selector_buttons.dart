import 'package:flutter/material.dart';
import 'package:pool_calculator/backend/database/storage_helper.dart';
import 'package:pool_calculator/domain/domain.dart';

class PocketSelectorButtons extends StatelessWidget {
  final CoordinateConverter converter;
  final StorageHelper storageHelper;
  final String? selectedPositionName;
  final ValueChanged<String> onSelectionChanged;
  final double buttonSize;

  const PocketSelectorButtons({
    super.key,
    required this.converter,
    required this.storageHelper,
    required this.selectedPositionName,
    required this.onSelectionChanged,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    final buttonMargin = buttonSize / 4;

    final borderThicknessPixels = converter.borderThicknessPixels();

    final offsetDistance = borderThicknessPixels + buttonMargin + (buttonSize / 2);

    final buttons = PocketPositions.tableCoordinates.entries.map((entry) {
      final name = entry.key;
      final coord = entry.value;

      final screen = converter.tableToScreen(coord);

      double horizontalDir = 0;
      if (coord.x < 0.5) {
        horizontalDir = -1;
      } else if (coord.x > 0.5) {
        horizontalDir = 1;
      }

      double verticalDir = 0;
      if (coord.y < 0.5) {
        verticalDir = -1;
      } else if (coord.y > 0.5) {
        verticalDir = 1;
      }

      final centerX = screen.x + (horizontalDir * offsetDistance);
      final centerY = screen.y + (verticalDir * offsetDistance);

      final left = centerX - (buttonSize / 2);
      final top = centerY - (buttonSize / 2);

      return (name: name, left: left, top: top);
    }).toList();

    Widget buildSelectorButton(String name, double left, double top) {
      final isSelected = selectedPositionName == name;
      return Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          onTap: () async {
            onSelectionChanged(name);
            await storageHelper.setSelectedPosition(name);
          },
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        ...buttons.map((b) => buildSelectorButton(b.name, b.left, b.top)),
      ],
    );
  }
}
