import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class ColorItem {
  final String label;
  final Color iconColor; // The specific color of the palette icon
  final String iconPath; // Path to your svg
  final String id; // Unique ID for selection

  ColorItem({
    required this.label,
    required this.iconColor,
    required this.iconPath,
    required this.id,
  });
}

class ColorSection {
  final String title;
  final List<ColorItem> items;

  ColorSection({required this.title, required this.items});
}

Future<ColorItem?> showColorGridSheet({
  required BuildContext context,
  required List<ColorSection> sections, // Pass sections instead of flat list
  String? currentId, // Currently selected ID
}) {
  const Color primaryBlue = Color(0xFF154DBB);

  return showModalBottomSheet<ColorItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final appTrans = AppTranslations.of(context);
      List<ColorSection> allSections = sections;
      List<ColorSection> filteredSections = sections;
      String? selectedId = currentId;
      final TextEditingController searchCtrl = TextEditingController();
      final isRTL = Directionality.of(context) == TextDirection.rtl;

      return StatefulBuilder(
        builder: (context, setState) {
          // Filter Logic
          void onSearch(String query) {
            if (query.isEmpty) {
              filteredSections = allSections;
            } else {
              List<ColorSection> tempSections = [];
              for (var section in allSections) {
                // Find items that match the query
                var matchingItems = section.items
                    .where((item) => item.label
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();

                // If section has matching items, add it to the list
                if (matchingItems.isNotEmpty) {
                  tempSections.add(ColorSection(
                      title: section.title, items: matchingItems));
                }
              }
              filteredSections = tempSections;
            }
            setState(() {});
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration:  BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: AppColors.secondary, width: 5)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            // Force RTL for the entire sheet content to match Arabic layout
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  // --- Drag Handle ---
                  Center(
                    child: Container(
                      width: 150,
                      height: 4,
                      margin: const EdgeInsets.only(top: 6, bottom: 25),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // --- Title ---
                  Text(
                    appTrans?.text('select.choose_color') ?? "Select Color",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // --- Subtitle ---
                  Text(
                    appTrans?.text('subtitle.select_color') ??
                        "Choose the color that fits your car's condition",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff676768),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Search Bar ---
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
                        controller: searchCtrl,
                        onChanged: onSearch,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: appTrans?.text('search.color') ??
                              "Search for color",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 5),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- Scrollable Content ---
                  Expanded(
                    child: filteredSections.isEmpty
                        ? Center(
                            child: Text(
                                appTrans?.text('error.no_results') ??
                                    "No results",
                                style:
                                    TextStyle(color: Colors.grey.shade400)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: filteredSections.length,
                            itemBuilder: (context, index) {
                              final section = filteredSections[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section Title
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, top: 12),
                                    child: Row(
                                      textDirection: isRTL
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                      mainAxisAlignment: isRTL
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          section.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          height: 14,
                                          width: 2,
                                          color: Colors
                                              .orange, // Orange accent line
                                        )
                                      ],
                                    ),
                                  ),

                                  // Grid/Wrap of Items
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      textDirection: isRTL
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      spacing: 10,
                                      runSpacing: 14,
                                      children: section.items.map((item) {
                                        final isSelected =
                                            selectedId == item.id;
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedId = item.id;
                                              // _colorValue = item.iconColor; // logic handled in parent
                                            });
                                            ColorItem? selectedItem;
                                            for (var s in sections) {
                                              for (var i in s.items) {
                                                if (i.id == selectedId)
                                                  selectedItem = i;
                                              }
                                            }
                                            Navigator.pop(ctx, selectedItem);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? primaryBlue.withValues(
                                                      alpha: 0.1)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: isSelected
                                                    ? primaryBlue
                                                    : Colors.grey.shade300,
                                                width: isSelected ? 1.5 : 1,
                                              ),
                                            ),
                                            child: Row(
                                              textDirection: isRTL
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  item.label,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                    color: isSelected
                                                        ? Colors.black
                                                        : Colors
                                                            .grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                // Assuming SVG, use color filter.
                                                // If using Icons, use Icon widget.
                                                SvgPicture.asset(
                                                  item.iconPath,
                                                  width: 18,
                                                  height: 18,
                                                  // Use the item's specific color
                                                  colorFilter:
                                                      ColorFilter.mode(
                                                          item.iconColor,
                                                          BlendMode.srcIn),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      onTap: () {
                        // Find the full item object to return
                        ColorItem? selectedItem;
                        for (var s in sections) {
                          for (var i in s.items) {
                            if (i.id == selectedId) selectedItem = i;
                          }
                        }
                        Navigator.pop(ctx, selectedItem);
                      },
                      text: appTrans?.text('confirm') ?? "Confirm",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
