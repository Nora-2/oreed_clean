import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.background = const Color.fromARGB(255, 237, 237, 239),
    this.borderColor = Colors.white,
    this.radius = 22,
    this.p = const EdgeInsets.all(16),
    this.boxShadows,
  });

  final Widget child;
  final Color background;
  final Color borderColor;
  final double radius;
  final EdgeInsets p;
  final List<BoxShadow>? boxShadows;

  @override
  Widget build(BuildContext context) {
    return Container(padding: p, child: child);
  }
}
