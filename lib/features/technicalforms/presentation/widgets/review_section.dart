// lib/view/screens/upload_ads/widgets/review/review_models.dart
import 'dart:io';
import 'package:flutter/material.dart';

class ReviewItem {
  final String label;
  final String value;
  final IconData? icon;
  const ReviewItem({required this.label, required this.value, this.icon});
}

class ReviewSection {
  final String keyName; // مفتاح فريد للقسم (للتعديل والـscroll)
  final String title;
  final List<ReviewItem> items;
  final List<File>? images; // اختياري: صور القسم (مثلاً صور المنتج/السيارة)
  final Widget? custom; // اختياري: محتوى مخصص
  const ReviewSection({
    required this.keyName,
    required this.title,
    required this.items,
    this.images,
    this.custom,
  });
}

class ReviewScreenResult {
  final bool confirmed; // true لو تم التأكيد والنشر
  final String?
  editSection; // مفتاح القسم المُراد تعديله لو المستخدم اختار Edit
  const ReviewScreenResult({required this.confirmed, this.editSection});
}
