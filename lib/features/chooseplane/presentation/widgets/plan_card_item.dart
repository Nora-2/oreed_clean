import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/chooseplane/domain/entities/package_entity.dart';

class PlanCardItem extends StatelessWidget {
  final PackageEntity package;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCardItem({super.key, 
    required this.package,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // UI logic for colors
    Color themeColor;
    bool isMostPopular = false;

    if (index == 0) {
      themeColor = const Color(0xFF154BB6);
    } else if (index == 1) {
      themeColor = const Color(0xFFFF9900);
      isMostPopular = true;
    } else {
      themeColor = const Color(0xFF8A2BE2);
    }

    final borderColor = isMostPopular ? themeColor : const Color(0xFFEEEEEE);
    // final isRTL = Directionality.of(context) == TextDirection.rtl;
    final t = AppTranslations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? themeColor : borderColor,
            width: isSelected || isMostPopular ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          package.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package.description,
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              "${package.price} ${t?.text('currency_kwd') ?? 'د.ك'}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: themeColor,
                              ),
                            ),
                            Text(
                              " / ${package.period} ${t?.text('day_unit') ?? 'يوم'}",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 40,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                  child: isMostPopular
                      ? Text(
                          "${package.period} ${t?.text('day_unit')}\n${t?.text('most_popular') ?? 'الاكثر طلبا'}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ))
                      : Text("${package.period} ${t?.text('day_unit')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ))),
            ),
            PositionedDirectional(
              top: 10,
              end: 5,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  color: isSelected ? themeColor : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}