
import 'package:flutter/material.dart';

class SegmentedTabs extends StatelessWidget {
  final TabController controller;
  final String allLabel;
  final String unreadLabel;

  const SegmentedTabs({super.key, required this.controller, required this.allLabel, required this.unreadLabel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Row(
          children: [
            _tabBtn(allLabel, controller.index == 0, () => controller.animateTo(0)),
            const SizedBox(width: 8),
            _tabBtn(unreadLabel, controller.index == 1, () => controller.animateTo(1)),
          ],
        );
      },
    );
  }

  Widget _tabBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1D4ED8) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: active ? null : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}