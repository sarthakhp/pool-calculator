import 'package:flutter/material.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InfoDialog(),
    );
  }

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Center(
              child: Icon(Icons.info_outline, size: 24, color: Colors.blueAccent),
            ),
          ),
          SizedBox(width: 8),
          Text('How to Use'),
        ],
      ),
      content: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          _InfoItem(
            icon: Icons.touch_app,
            text: 'Drag the balls / target to move them around the table.',
          ),
          SizedBox(height: 12),
          _InfoItem(
            icon: Icons.circle,
            text: 'The black ball is the target where you want to send the object ball.',
          ),
          SizedBox(height: 12),
          _InfoItem(
            icon: Icons.visibility,
            text: 'The side panel shows exactly where to hit the object ball to send it to the target.',
          ),
          SizedBox(height: 12),
          _InfoItem(
            icon: Icons.tune,
            text: 'Adjust friction and ball speed to correct for cut-induced throw.',
          ),
          SizedBox(height: 12),
          _InfoItem(
            icon: Icons.screen_rotation,
            text: 'Always use the app in landscape mode for the best experience.',
          ),
          ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it!'),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: Icon(icon, size: 20, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

