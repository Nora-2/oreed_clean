// import 'package:flutter/material.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:provider/provider.dart';

// import '../../../../translation/appTranslations.dart';
// import '../../../car_ads/domain/entities/brand_entity.dart';
// import '../../../car_ads/domain/entities/car_model_entity.dart';
// import '../providers/car_brand_model_provider.dart';

// class BrandModelSelectorRow extends StatefulWidget {
//   final int sectionId;
//   final ValueChanged<BrandEntity>? onBrandSelected;
//   final ValueChanged<CarModelEntity>? onModelSelected;

//   const BrandModelSelectorRow({
//     super.key,
//     required this.sectionId,
//     this.onBrandSelected,
//     this.onModelSelected,
//   });

//   @override
//   State<BrandModelSelectorRow> createState() => _BrandModelSelectorRowState();
// }

// class _BrandModelSelectorRowState extends State<BrandModelSelectorRow> {
//   BrandEntity? _selectedBrand;
//   CarModelEntity? _selectedModel;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CarBrandModelProvider>();
//     final appTrans = AppTranslations.of(context);

//     final Color borderColor = Colors.grey.shade300;
//     final Color primary = Colors.teal.shade600;

//     return Row(
//       children: [
//         _buildSelectButton(
//           context,
//           label: _selectedBrand?.name ??
//               (appTrans?.text('select.choose_brand') ?? 'اختر الماركة'),
//           icon: Icons.directions_car_rounded,
//           color: primary,
//           borderColor: borderColor,
//           onTap: () async {

//             await provider.fetchBrands(widget.sectionId);
//             print(provider.brands.isEmpty);
//             if (provider.brands.isEmpty) return;

//             final chosen = await _showOptions(
//               context,
//               title: appTrans?.text('select.choose_brand') ?? 'اختر الماركة',
//               items: provider.brands.map((b) => b.name ?? '').toList(),
//             );

//             if (chosen != null) {
//               final brand = provider.brands.firstWhere((b) => b.name == chosen);
//               setState(() {
//                 _selectedBrand = brand;
//                 _selectedModel = null;
//               });
//               widget.onBrandSelected?.call(brand);
//               await provider.fetchModels(brand.id);
//             }
//           },
//         ),
//         const SizedBox(width: 8),
//         _buildSelectButton(
//           context,
//           label: _selectedModel?.name ??
//               (appTrans?.text('select.choose_model') ?? 'اختر الموديل'),
//           icon: Icons.directions_car_filled_rounded,
//           color: Colors.orange.shade700,
//           borderColor: borderColor,
//           onTap: () async {
//             if (_selectedBrand == null) return;
//             await provider.fetchModels(_selectedBrand!.id);
//             if (provider.models.isEmpty) return;

//             final chosen = await _showOptions(
//               context,
//               title: appTrans?.text('select.choose_model') ?? 'اختر الموديل',
//               items: provider.models.map((m) => m.name ?? '').toList(),
//             );

//             if (chosen != null) {
//               final model = provider.models.firstWhere((m) => m.name == chosen);
//               setState(() => _selectedModel = model);
//               widget.onModelSelected?.call(model);
//             }
//           },
//         ),
//       ],
//     );
//   }

//   // 🧱 Clean reusable select button
//   Widget _buildSelectButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required Color color,
//     required Color borderColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 46,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: borderColor),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.08),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(width: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: label.contains('اختر') ? Colors.grey : Colors.black87,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🩵 Polished modal bottom sheet for selection
//   Future<String?> _showOptions(
//     BuildContext context, {
//     required String title,
//     required List<String> items,
//   }) async {
//     return showModalBottomSheet<String>(
//       context: context,
//       backgroundColor: Colors.white,
//       elevation: 6,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       isScrollControlled: true,
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade400,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Flexible(
//                   child: ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => Divider(
//                       color: Colors.grey.shade200,
//                       height: 1,
//                     ),
//                     itemBuilder: (context, index) {
//                       final name = items[index];
//                       return ListTile(
//                         dense: true,
//                         title: Text(
//                           name,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         trailing: const Icon(Icons.arrow_forward_ios_rounded,
//                             size: 14, color: Colors.teal),
//                         onTap: () => Navigator.pop(context, name),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.redAccent,
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                   child: Builder(
//                     builder: (context) {
//                       final t = AppTranslations.of(context);
//                       return Text(t?.text('cancel') ?? 'إلغاء');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
