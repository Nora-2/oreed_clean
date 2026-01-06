// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

// // ----------------------------- Result Model ------------------------------ //
// class GeneralFilterResult {
//   final String? stateLabel;
//   final String? cityLabel;
//   final RangeValues? price;
//   final RangeValues? area;
//   final String? rooms;
//   final String? baths;
//   final String? floor;
//   final Map filterMap;

//   const GeneralFilterResult({
//     this.stateLabel,
//     this.cityLabel,
//     this.price,
//     this.area,
//     this.rooms,
//     this.baths,
//     this.floor,
//     required this.filterMap,
//   });
// }

// // ----------------------------- Public API -------------------------------- //
// Future<GeneralFilterResult?> showGeneralFilterSheet({
//   required BuildContext context,
//   required int sectionId,
//   String? stateLabel,
//   String? cityLabel,
//   RangeValues? price,
//   RangeValues? area,
//   String? rooms,
//   String? baths,
//   String? floor,
//   String? areaLabel,
//   required Map currentFilterMap,
// }) async {
//   final loc = context.read<LocationProvider>();
//   final carBM = context.read<CarBrandModelProvider>();

//   // Pre-fetch data if needed so lists are ready when sheet opens
//   if (loc.states.isEmpty) {
//     loc.fetchStates(1); // Assuming country ID 1
//   }

//   if (sectionId != 2 && carBM.brands.isEmpty) {
//     carBM.fetchBrands(sectionId);
//   }

//   // If a state is already selected but cities aren't loaded, try to load cities
//   if (currentFilterMap['state_id'] != null && loc.cities.isEmpty) {
//     loc.fetchCities(currentFilterMap['state_id']);
//   }

//   // If a brand is selected, load models
//   if (currentFilterMap['brand_id'] != null && carBM.models.isEmpty) {
//     carBM.fetchModels(
//         int.tryParse(currentFilterMap['brand_id'].toString()) ?? 0);
//   }

//   return showModalBottomSheet<GeneralFilterResult>(
//     context: context,
//     isScrollControlled: true,
//     useSafeArea: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(30),
//       ),
//     ),
//     builder: (sheetCtx) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider.value(value: loc),
//           ChangeNotifierProvider.value(value: carBM),
//         ],
//         child: _GeneralFilterContent(
//           sectionId: sectionId,
//           initialStateLabel: stateLabel,
//           initialCityLabel: cityLabel,
//           initialPrice: price,
//           initialArea: area,
//           initialRooms: rooms,
//           initialAreaLabel: areaLabel,
//           initialBaths: baths,
//           initialFloor: floor,
//           initialFilterMap: currentFilterMap,
//         ),
//       );
//     },
//   );
// }

// // ----------------------------- Content Widget ---------------------------- //
// class _GeneralFilterContent extends StatefulWidget {
//   final int sectionId;
//   final String? initialStateLabel;
//   final String? initialCityLabel;
//   final RangeValues? initialPrice;
//   final RangeValues? initialArea;
//   final String? initialAreaLabel;
//   final String? initialRooms;
//   final String? initialBaths;
//   final String? initialFloor;
//   final Map initialFilterMap;

//   const _GeneralFilterContent({
//     required this.sectionId,
//     required this.initialStateLabel,
//     required this.initialCityLabel,
//     required this.initialPrice,
//     required this.initialArea,
//     required this.initialAreaLabel,
//     required this.initialRooms,
//     required this.initialBaths,
//     required this.initialFloor,
//     required this.initialFilterMap,
//   });

//   @override
//   State<_GeneralFilterContent> createState() => _GeneralFilterContentState();
// }

// class _GeneralFilterContentState extends State<_GeneralFilterContent> {
//   // UI State selections
//   late String? _stateL = widget.initialStateLabel;
//   late String? _cityL = widget.initialCityLabel;
//   late String? _brandL; // Will determine based on map in init
//   late String? _modelL;
//   String? _areaLabel;

//   // Value Ranges & Discrete values
//   late RangeValues _price = widget.initialPrice ?? const RangeValues(0, 0);
//   late RangeValues _area = widget.initialArea ?? const RangeValues(0, 0);
//   late String? _rooms = widget.initialRooms;
//   late String? _baths = widget.initialBaths;
//   late String? _floor = widget.initialFloor;

//   // The Data Map
//   late final Map _filters = Map.of(widget.initialFilterMap);

//   final int _currentYear = DateTime.now().year;
//   late String _year = _currentYear.toString();

//   @override
//   void initState() {
//     super.initState();
//     _areaLabel = widget.initialAreaLabel;
//   }

//   // ----------------------- UI Helper Methods ----------------------- //

//   Widget _buildDragHandle() {
//     return Center(
//       child: Container(
//         width: 150,
//         height: 5,
//         margin: const EdgeInsets.only(top: 12, bottom: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//      final isRTL=Directionality.of(context) == TextDirection.rtl;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         textDirection: isRTL?TextDirection.ltr:TextDirection.rtl,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: _clearAll,
//             borderRadius: BorderRadius.circular(20),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 textDirection: isRTL?TextDirection.ltr:TextDirection.rtl,
//                 children: [
//                   Text(
//                     AppTranslations.of(context)!.text('common.clear') ?? "مسح",
//                     style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey),
//                   ),
//                   const SizedBox(width: 4),
//                   SvgPicture.asset('assets/svg/Vector.svg'),
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             AppTranslations.of(context)!.text('filter.title') ?? 'تصفية النتائج',
//             style: const TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
//           ),
//           const SizedBox(width: 50),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     final isRTL=Directionality.of(context) == TextDirection.rtl;
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
//       child: Row(
//         textDirection: isRTL?TextDirection.ltr:TextDirection.rtl,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             textDirection: isRTL?TextDirection.ltr:TextDirection.rtl,
//             title,
//             style: const TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             height: 20,
//             width: 3,
//             decoration: BoxDecoration(
//                 color: const Color(0xFFF6A609),
//                 borderRadius: BorderRadius.circular(2)),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- The New Grid Builder ---
//   Widget _buildSelectionGrid<T>(
//       {required List<T> items,
//       required String Function(T) labelBuilder,
//       required bool Function(T) isSelected,
//       required void Function(T) onSelect,
//       IconData? icon,
//       String? svgicon}) {
//     if (items.isEmpty) return const SizedBox.shrink();
//  final isRTL=Directionality.of(context) == TextDirection.rtl;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//         width: double.infinity,
//         child: Wrap(
//           textDirection: isRTL?TextDirection.rtl:TextDirection.ltr,
//           spacing: 10,
//           runSpacing: 10,
//           alignment: WrapAlignment.start,
//           children: items.map((item) {
//             final selected = isSelected(item);
//             return _buildSelectableChip(
//               label: labelBuilder(item),
//               isSelected: selected,
//               onTap: () => onSelect(item),
//               icon: icon,
//               svgicon: svgicon,
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectableChip({
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//     IconData? icon,
//     String? svgicon,
//   }) {
//     // Styling matches the image
//     final borderColor =
//         isSelected ? AppColors.primary : Colors.grey.shade200;
//     final bgColor =
//         isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white;
//     final textColor = isSelected ? AppColors.black : Colors.grey.shade600;
//     final fontWeight = isSelected ? FontWeight.w800 : FontWeight.w500;
//  final isRTL=Directionality.of(context) == TextDirection.rtl;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: borderColor, width: 1.5),
//         ),
//         child: Row(
//           textDirection: isRTL?TextDirection.ltr:TextDirection.rtl,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Text First (Left) then Icon (Right) because of RTL Wrap,
//             // but strictly inside the row:
//             Text(
//               label,
//               style: TextStyle(
//                   color: textColor, fontSize: 13, fontWeight: fontWeight),
//             ),
//             const SizedBox(width: 8),
//             svgicon != null
//                 ? SvgPicture.asset(svgicon, color: textColor)
//                 : Icon(icon, size: 18, color: textColor),
//           ],
//         ),
//       ),
//     );
//   }

//   // ----------------------------- Actions ----------------------------- //

//   void _clearAll() {
//     setState(() {
//       _stateL = null;
//       _cityL = null;
//       _price = const RangeValues(0, 0);
//       _area = const RangeValues(0, 0);
//       _rooms = null;
//       _baths = null;
//       _floor = null;
//       _year = '';
//       _brandL = null;
//       _modelL = null;
//       _areaLabel = null;
//       _filters.clear();
//     });
//     // Optional: Refresh providers to clear sub-lists if desired, or keep cache
//   }

//   void _apply() {
//     final priceToReturn =
//         (_price.start == 0 && _price.end == 0) ? null : _price;
//     final areaToReturn = (_area.start == 0 && _area.end == 0) ? null : _area;

//     Navigator.pop(
//       context,
//       GeneralFilterResult(
//         stateLabel: _stateL,
//         cityLabel: _cityL,
//         price: priceToReturn,
//         area: areaToReturn,
//         rooms: _rooms,
//         baths: _baths,
//         floor: _floor,
//         filterMap: _filters,
//       ),
//     );
//   }

//   // Only keeping Price/Year range pickers as Bottom Sheets since they require number inputs
//   Future<void> _pickPrice() async {
//     final t = AppTranslations.of(context);
//     final res = await showPriceBottomSheet(
//       context,
//       min: 0,
//       max: 1000000,
//       initial: _price,
//       title:
//           '${t?.text('price') ?? 'السعر'} (${t?.text('currency_kwd') ?? 'د.ك'})',
//     );
//     if (res != null) {
//       setState(() => _price = res);
//       _filters['min_price'] = _price.start.toString();
//       _filters['max_price'] = _price.end.toString();
//     }
//   }

//   List<OptionItemregister> _toOptionItems(
//     List<String> labels,
//   ) {
//     return List.generate(labels.length,
//         (i) => OptionItemregister(label: labels[i], colorTag: i));
//   }

//   Future<String?> openYearSheet(
//       BuildContext context, String? currentYear) async {
//     final nowYear = DateTime.now().year;

//     final recent = <String>[];
//     final mid = <String>[];
//     final old = <String>[];
//     final classic = <String>[]; // جديد: قسم كلاسيكي

//     for (int y = nowYear + 1; y >= 2021; y--) {
//       recent.add(y.toString());
//     }
//     for (int y = 2020; y >= 2010; y--) {
//       mid.add(y.toString());
//     }
//     for (int y = 2009; y >= 1990; y--) {
//       old.add(y.toString());
//     }
//     for (int y = 1989; y >= 1970; y--) {
//       classic.add(y.toString());
//     }

//     final groupedOptions = {
//       AppTranslations.of(context)!.text('filter.year.recent') ?? 'حديث:': _toOptionItems(recent),
//       AppTranslations.of(context)!.text('filter.year.mid') ?? 'متوسطة:': _toOptionItems(mid),
//       AppTranslations.of(context)!.text('filter.year.old') ?? 'قديمة:': _toOptionItems(old),
//       AppTranslations.of(context)!.text('filter.year.classic') ?? 'كلاسيكي:': _toOptionItems(classic),
//     };

//     return showAppOptionSheetregistergridyear(
//       context: context,
//       title: AppTranslations.of(context)!.text('filter.choose_year') ?? 'اختر السنة',
//       subtitle: AppTranslations.of(context)!.text('select.year_subtitle') ?? 'حدد سنة الموديل لعرض مواصفاته الصحيحة.',
//       hint: AppTranslations.of(context)!.text('select.search_year') ?? 'ابحث عن السنة',
//       groupedOptions: groupedOptions,
//       current: currentYear,
//     );
//   }

//   Future<void> _pickYear() async {
//     // استدعاء الشيت الذي يعرض التقسيمات (حديث/قديم)
//     final String? selectedYear = await openYearSheet(context, _year);

//     if (selectedYear != null) {
//       setState(() {
//         _year = selectedYear; // تحديث النص المعروض في الواجهة

//         // إرسال السنة المختارة كمدى (من نفس السنة إلى نفس السنة)
//         _filters['min_year'] = selectedYear;
//         _filters['max_year'] = selectedYear;
//       });
//     }
//   }

//   // -------------------------------- Build -------------------------------- //
//   @override
//   Widget build(BuildContext context) {
//     final isRealEstate = widget.sectionId == 2;
//      final isRTL=Directionality.of(context) == TextDirection.rtl;
//     final bool isPriceSet = !(_price.start == 0 && _price.end == 0);
//     final String startPrice = isPriceSet
//         ? '${_price.start.toInt()} ${AppTranslations.of(context)!.text('currency_kwd') ?? 'د.ك'}'
//         : AppTranslations.of(context)!.text('filter.price_hint_1') ?? '100 دينار كويتي';
//     final String endPrice = isPriceSet
//         ? '${_price.end.toInt()} ${AppTranslations.of(context)!.text('currency_kwd') ?? 'د.ك'}'
//         : AppTranslations.of(context)!.text('filter.price_hint_2') ?? '300 دينار كويتي';
//     final Color priceTextColor = isPriceSet ? Colors.black87 : Colors.grey;

//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           border: const Border(
//               top: BorderSide(color: AppColors.seccolor, width: 3))),
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.90,
//         child: Column(
//           children: [
//             _buildDragHandle(),
//             _buildHeader(),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_governorate') ?? ':المحافظة'),
//                     Consumer<LocationProvider>(
//                       builder: (context, loc, _) {
//                         return _buildSelectionGrid(
//                             items: loc.states,
//                             labelBuilder: (s) => s.name ?? '',
//                             isSelected: (s) => (s.name == _stateL),
//                             // or compare ID
//                             onSelect: (s) {
//                               setState(() {
//                                 _stateL = s.name;
//                                 _cityL = null; // Reset city on state change
//                                 _filters['state_id'] = s.id;
//                                 _filters.remove('city_id');
//                               });
//                               loc.fetchCities(s.id);
//                             },
//                             svgicon: 'assets/svg/locationcontiry.svg');
//                       },
//                     ),

//                     Consumer<LocationProvider>(
//                       builder: (context, loc, _) {
//                         if (loc.cities.isEmpty) return const SizedBox.shrink();
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_area_city') ?? ':المنطقة'),
//                             _buildSelectionGrid(
//                                 items: loc.cities,
//                                 labelBuilder: (c) => c.name ?? '',
//                                 isSelected: (c) => (c.name == _cityL),
//                                 onSelect: (c) {
//                                   setState(() {
//                                     _cityL = c.name;
//                                     _filters['city_id'] = c.id;
//                                   });
//                                 },
//                                 svgicon: 'assets/svg/location.svg'),
//                           ],
//                         );
//                       },
//                     ),
//                     _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_price') ?? ':السعر'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         textDirection: TextDirection.ltr,
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: _pickPrice,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(AppTranslations.of(context)!.text('filter.highest_price') ?? "أعلي سعر",
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.blackColor)),
//                                   const SizedBox(height: 8),
//                                   Container(
//                                     height: 48,
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.grey.shade300),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(endPrice,
//                                         style: TextStyle(
//                                             color: priceTextColor,
//                                             fontSize: 12)),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: InkWell(
//                               onTap: _pickPrice,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(AppTranslations.of(context)!.text('filter.lowest_price') ?? "أدني سعر",
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.blackColor)),
//                                   const SizedBox(height: 8),
//                                   Container(
//                                     height: 48,
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.grey.shade300),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(startPrice,
//                                         style: TextStyle(
//                                           color: priceTextColor,
//                                           fontSize: 12,
//                                         )),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // 3. VARIABLE SECTIONS
//                     if (isRealEstate) ...[
//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_space') ?? ':المساحة'),
//                       _buildSelectionGrid<String>(
//                         items: [
//                           AppTranslations.of(context)!.text('filter.area_lt_50') ?? 'أقل من 50 م²',
//                           AppTranslations.of(context)!.text('filter.area_50_80') ?? 'من 50 - 80 م²',
//                           AppTranslations.of(context)!.text('filter.area_80_120') ?? 'من 80 - 120 م²',
//                           AppTranslations.of(context)!.text('filter.area_120_150') ?? 'من 120 - 150 م²',
//                           AppTranslations.of(context)!.text('filter.area_150_200') ?? 'من 150 - 200 م²',
//                           AppTranslations.of(context)!.text('filter.area_200_300') ?? 'من 200 - 300 م²',
//                           AppTranslations.of(context)!.text('filter.area_gt_300') ?? 'أكثر من 300 م²'
//                         ],
//                         labelBuilder: (val) => val,
//                         isSelected: (val) => _areaLabel == val,
//                         // التأكد من المقارنة
//                         onSelect: (val) {
//                           setState(() {
//                             _areaLabel = val; // تحديث الحالة

//                             // منطق الفلترة
//                             if (val == (AppTranslations.of(context)!.text('filter.area_lt_50') ?? 'أقل من 50 م²')) {
//                               _filters['min_area'] = '0';
//                               _filters['max_area'] = '50';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_50_80') ?? 'من 50 - 80 م²')) {
//                               _filters['min_area'] = '50';
//                               _filters['max_area'] = '80';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_80_120') ?? 'من 80 - 120 م²')) {
//                               _filters['min_area'] = '80';
//                               _filters['max_area'] = '120';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_120_150') ?? 'من 120 - 150 م²')) {
//                               _filters['min_area'] = '120';
//                               _filters['max_area'] = '150';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_150_200') ?? 'من 150 - 200 م²')) {
//                               _filters['min_area'] = '150';
//                               _filters['max_area'] = '200';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_200_300') ?? 'من 200 - 300 م²')) {
//                               _filters['min_area'] = '200';
//                               _filters['max_area'] = '300';
//                             } else if (val == (AppTranslations.of(context)!.text('filter.area_gt_300') ?? 'أكثر من 300 م²')) {
//                               _filters['min_area'] = '300';
//                               _filters.remove('max_area');
//                             }
//                           });
//                         },
//                         svgicon:
//                             'assets/svg/area.svg', // ضع مسار أيقونة صحيح أو اجعلها null
//                       ),
//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_rooms') ?? ':عدد الغرف'),
//                       _buildSelectionGrid(
//                           items: [
//                             AppTranslations.of(context)!.text('filter.room_1') ?? 'غرفة',
//                             AppTranslations.of(context)!.text('filter.room_2') ?? 'غرفتين',
//                             AppTranslations.of(context)!.text('filter.room_3') ?? '3 غرف',
//                             AppTranslations.of(context)!.text('filter.room_4') ?? '4 غرف',
//                             AppTranslations.of(context)!.text('filter.room_5_plus') ?? 'غرف 5+'
//                           ],
//                           labelBuilder: (val) => val,
//                           isSelected: (val) => _rooms == val,
//                           onSelect: (val) {
//                             setState(() {
//                               _rooms = val;
//                               _filters['min_room'] = val;
//                               _filters['max_room'] = val;
//                             });
//                           },
//                           svgicon: 'assets/svg/bed.svg'),
//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_baths') ?? ': الحمامات'),
//                       _buildSelectionGrid(
//                         items: [
//                           AppTranslations.of(context)!.text('filter.bath_1') ?? '1 حمّام',
//                           AppTranslations.of(context)!.text('filter.bath_2') ?? '2 حمّامات',
//                           AppTranslations.of(context)!.text('filter.bath_3') ?? '3 حمّامات',
//                           AppTranslations.of(context)!.text('filter.bath_4') ?? '4 حمّامات',
//                           AppTranslations.of(context)!.text('filter.bath_5_plus') ?? '+5 حمّامات'
//                         ],
//                         labelBuilder: (val) => val,
//                         isSelected: (val) => _baths == val,
//                         onSelect: (val) {
//                           setState(() {
//                             _baths = val;
//                             _filters['min_bathroom'] = val;
//                             _filters['max_bathroom'] = val;
//                           });
//                         },
//                         svgicon: 'assets/svg/bath.svg',
//                       ),
//                       Wrap(

//                           textDirection: isRTL?TextDirection.rtl:TextDirection.ltr,
//                           spacing: 8,
//                           runSpacing: 10,
//                           children: [
//                             _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_floor') ?? ':الدور'),
//                             _buildSelectionGrid<String>(
//                               items: [
//                                 AppTranslations.of(context)!.text('filter.floor_ground') ?? 'أرضي',
//                                 AppTranslations.of(context)!.text('filter.floor_low') ?? 'مرتفع بسيط (1-2)',
//                                 AppTranslations.of(context)!.text('filter.floor_mid') ?? 'متوسط (3-4)',
//                                 AppTranslations.of(context)!.text('filter.floor_high') ?? 'عالي (+5)'
//                               ],
//                               labelBuilder: (val) => val,
//                               isSelected: (val) => _floor == val,
//                               onSelect: (val) {
//                                 setState(() {
//                                   _floor = val;
//                                   if (val == (AppTranslations.of(context)!.text('filter.floor_ground') ?? 'أرضي')) {
//                                     _filters['min_floor'] = '0';
//                                     _filters['max_floor'] = '0';
//                                   } else if (val == (AppTranslations.of(context)!.text('filter.floor_low') ?? 'مرتفع بسيط (1-2)')) {
//                                     _filters['min_floor'] = '1';
//                                     _filters['max_floor'] = '2';
//                                   } else if (val == (AppTranslations.of(context)!.text('filter.floor_mid') ?? 'متوسط (3-4)')) {
//                                     _filters['min_floor'] = '3';
//                                     _filters['max_floor'] = '4';
//                                   } else if (val == (AppTranslations.of(context)!.text('filter.floor_high') ?? 'عالي (+5)')) {
//                                     _filters['min_floor'] = '5';
//                                     _filters['max_floor'] = '100';
//                                   }
//                                 });
//                               },
//                               svgicon: 'assets/svg/floor.svg',
//                             ),
//                           ]),
//                     ] else if (widget.sectionId == 1) ...[
//                       // --- Car Details ---
//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_brand') ?? ':الماركة'),
//                       Consumer<CarBrandModelProvider>(
//                         builder: (context, carBM, _) {
//                           return _buildSelectionGrid(
//                               items: carBM.brands,
//                               labelBuilder: (b) => b.name ?? '',
//                               isSelected: (b) =>
//                                   _filters['brand_id'].toString() ==
//                                   b.id.toString(),
//                               onSelect: (b) {
//                                 setState(() {
//                                   _brandL = b.name;
//                                   _modelL = null;
//                                   _filters['brand_id'] = b.id.toString();
//                                   _filters.remove('car_model_id');
//                                 });
//                                 carBM.fetchModels(b.id);
//                               },
//                               svgicon: 'assets/svg/car.svg');
//                         },
//                       ),

//                       Consumer<CarBrandModelProvider>(
//                         builder: (context, carBM, _) {
//                           if (carBM.models.isEmpty)
//                             return const SizedBox.shrink();
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_model') ?? ':الموديل'),
//                               _buildSelectionGrid(
//                                   items: carBM.models,
//                                   labelBuilder: (m) => m.name ?? '',
//                                   isSelected: (m) =>
//                                       _filters['car_model_id'].toString() ==
//                                       m.id.toString(),
//                                   onSelect: (m) {
//                                     setState(() {
//                                       _modelL = m.name;
//                                       _filters['car_model_id'] =
//                                           m.id.toString();
//                                     });
//                                   },
//                                   svgicon: 'assets/svg/car.svg'),
//                             ],
//                           );
//                         },
//                       ),

//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_year') ?? ':سنة الصنع'),
//                       Padding(
//                         padding: isRTL? const EdgeInsets.only(left: 280, right: 10): const EdgeInsets.only(left: 10, right: 260),
//                         child: _buildSelectableChip(
//                           label: AppTranslations.of(context)!.text('filter.choose_year') ?? 'اختر السنة',
//                           isSelected: !(_year == ''),
//                           onTap: _pickYear,
//                           icon: Icons.calendar_month,
//                         ),
//                       ),

//                       _buildSectionTitle(AppTranslations.of(context)!.text('filter.section_inspection') ?? ': شهادة الفحص '),
//                       _buildSelectionGrid<String>(
//                         items: [
//                           AppTranslations.of(context)!.text('filter.inspection_included') ?? 'يشمل شهادة فحص',
//                           AppTranslations.of(context)!.text('filter.inspection_all') ?? 'الكل'
//                         ],
//                         labelBuilder: (val) => val,
//                         isSelected: (val) {
//                           // If the key doesn't exist, 'الكل' is selected
//                           if (!_filters.containsKey('has_document'))
//                             return val == (AppTranslations.of(context)!.text('filter.inspection_all') ?? 'الكل');
//                           return _filters['has_document'] ==
//                               (val == (AppTranslations.of(context)!.text('filter.inspection_included') ?? 'يشمل شهادة فحص') ? '1' : '0');
//                         },
//                         onSelect: (val) {
//                           setState(() {
//                             if (val == (AppTranslations.of(context)!.text('filter.inspection_included') ?? 'يشمل شهادة فحص')) {
//                               _filters['has_document'] = '1';
//                             } else {
//                               // If 'الكل', remove the key completely (like _sanitizeFilters)
//                               _filters.remove('has_document');
//                             }
//                           });
//                           debugPrint('FILTER PARAMS => $_filters');
//                         },
//                         icon: Icons.edit_document,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),

//             // ---------------- Footer ---------------- //
//             Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: CustomButton(onTap: _apply, text: AppTranslations.of(context)!.text('apply') ?? 'تصفية')),
//           ],
//         ),
//       ),
//     );
//   }
// }
