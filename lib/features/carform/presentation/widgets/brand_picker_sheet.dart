
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/carform/data/models/brand.dart';

Future<Brand?> showBrandPickerSheet({
  required BuildContext context,
  required Future<List<Brand>> Function() loadBrands,
  Color accentColor = const Color(0xFF0A84FF),
  String? title,
  String? searchHint,
  String? selectedId,
}) {
  final appTrans = AppTranslations.of(context);
  final effectiveTitle = title ?? appTrans?.text('select.choose_brand') ?? 'Select Brand';
  final effectiveSearchHint = searchHint ?? appTrans?.text('select.search_brand') ?? 'Search for brand';
  return showModalBottomSheet<Brand>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (ctx) {
      final controller = TextEditingController();
    final isRTL = Directionality.of(context) == TextDirection.rtl;
      return SafeArea(
        top: false,
        child: StatefulBuilder(
          builder: (ctx, setS) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration:  BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: AppColors.secondary, width: 5)),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ), // Max height
              child: Column(
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 150,
                      height: 5,
                      margin: const EdgeInsets.only(top: 12, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // --- Title ---
                  Text(
                    effectiveTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // --- Subtitle ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      appTrans?.text('subtitle.select_brand') ?? 'To show the appropriate car models for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- SEARCH BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller,
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                        // RTL Text
                        style: const TextStyle(fontSize: 14),
                        onChanged: (val) {
                          setS(() {});
                        },
                        decoration: InputDecoration(
                          hintText: effectiveSearchHint,
                          hintStyle: const TextStyle(
                            color: Color(0xff676768),
                            fontSize: 14,
                          ),
                          // Remove default underline
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 10, top: 15, bottom: 15),
                            child: SvgPicture.asset(
                             AppIcons.search,
                              width: 10,
                              height: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title

                  // Data Grid
                  Expanded(
                    child: FutureBuilder<List<Brand>>(
                      future: loadBrands(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snap.hasError) {
                          return Center(
                            child: Text('${appTrans?.text('ad_details.error_occurred') ?? 'Error occurred: '}${snap.error}'),
                          );
                        }

                        final brands = snap.data ?? <Brand>[];
                        final q = controller.text.trim();

                        // Local Filtering
                        final filtered = q.isEmpty
                            ? brands
                            : brands
                                .where((b) => b.name
                                    .toLowerCase()
                                    .contains(q.toLowerCase()))
                                .toList();

                        if (filtered.isEmpty) {
                          return Center(child: Text(appTrans?.text('common.noResults') ?? 'No results matching your search'));
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(
                              bottom: 20, top: 10, right: 6, left: 6),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 3 items per row like screenshot
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.1, // Adjust height/width ratio
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final b = filtered[i];
                            // Ensure ID types match (String vs Int)
                            final isSel =
                                b.id.toString() == selectedId.toString();

                            return _BrandTile(
                              brand: b,
                              accentColor: accentColor,
                              isSelected: isSel,
                              onTap: () => Navigator.pop(ctx, b),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: CustomButton(
                        onTap: () {
                          Navigator.pop(
                            ctx,
                          );
                        },
                        text: appTrans?.text('common.confirm') ?? "Confirm"),
                  )
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

// Single Item Tile (Logo + Name)
class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.brand,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  final Brand brand;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected ? accentColor : const Color(0xFFE6E9EF),
              width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: brand.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius:BorderRadius.all(Radius.circular(12)),
                  ),
                  errorWidget: (_, __, ___) =>
                      Icon(Icons.directions_car, color: Colors.grey[400]),
                ),
              ),
            ),
            // Name
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
              child: Text(
                brand.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
