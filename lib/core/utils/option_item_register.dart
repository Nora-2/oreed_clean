import 'package:flutter/material.dart';

class OptionItem {
  final String label;
  final IconData icon;
  /// لتلوين الأيقونة/الإطار (0..1..2..)، انت تختار دلالتها
  final int colorTag;
  const OptionItem({
    required this.label,
    required this.icon,
    this.colorTag = 0,
  });
}
class OptionItemregister {
  final String label;
  final String ?icon;
  /// لتلوين الأيقونة/الإطار (0..1..2..)، انت تختار دلالتها
  final int colorTag;
  const OptionItemregister({
    required this.label,
     this.icon,
    this.colorTag = 0,
  });
}

