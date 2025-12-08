import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pool_calculator/domain/domain.dart';
import 'deck_item.dart';

class CoordinateInputDeckItem extends DeckItem {
  final String label;
  final TableCoordinate coordinate;
  final ValueChanged<TableCoordinate> onChanged;

  const CoordinateInputDeckItem({
    super.key,
    required this.label,
    required this.coordinate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;
    final fontSize = shortestSide * 0.025;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: fontSize),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _CoordinateTextField(
                  label: 'X',
                  value: coordinate.x,
                  onChanged: (x) => onChanged(TableCoordinate(x, coordinate.y)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CoordinateTextField(
                  label: 'Y',
                  value: coordinate.y,
                  onChanged: (y) => onChanged(TableCoordinate(coordinate.x, y)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoordinateTextField extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _CoordinateTextField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_CoordinateTextField> createState() => _CoordinateTextFieldState();
}

class _CoordinateTextFieldState extends State<_CoordinateTextField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  double _toDisplay(double value) => value * 100;
  double _fromDisplay(double displayValue) => displayValue / 100;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _toDisplay(widget.value).toStringAsFixed(0));
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(_CoordinateTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isFocused && oldWidget.value != widget.value) {
      _controller.text = _toDisplay(widget.value).toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    final parsed = double.tryParse(text);
    if (parsed != null) {
      final clamped = parsed.clamp(0.0, 100.0);
      widget.onChanged(_fromDisplay(clamped));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
      ),
      onChanged: _onChanged,
    );
  }
}

