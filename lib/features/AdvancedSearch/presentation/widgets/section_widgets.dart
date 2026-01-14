import 'package:flutter/material.dart';
import 'package:oreed_clean/core/constants.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/features/AdvancedSearch/data/models/advanced_search_model.dart';

class SectionCardWidget extends StatelessWidget {
  final SearchSection section;
  const SectionCardWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xffE8E8E9).withOpacity(.15),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.orange, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 8),
              Text(
                section.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff333333)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (section.companies.isNotEmpty) ...[
            Text('${tr?.text('search_results_companies') ?? 'Companies'} (${section.companyCount})',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            _GridWidget(items: section.companies, isCompany: true, sectionId: section.sectionId),
            const SizedBox(height: 20),
          ],
          if (section.categories.isNotEmpty) ...[
            Text('${tr?.text('search_results_categories') ?? 'Categories'} (${section.categoryCount})',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            _GridWidget(items: section.categories, isCompany: false, sectionId: section.sectionId),
          ],
        ],
      ),
    );
  }
}

/// Grid Widget for Companies/Categories
class _GridWidget extends StatelessWidget {
  final List<dynamic> items;
  final bool isCompany;
  final int sectionId;

  const _GridWidget({required this.items, required this.isCompany, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: isCompany ? 12 : 6,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _GridItemWidget(
          id: item.id,
          name: item.name,
          image: isCompany ? Appimage.companyTest : Appimage.buildTest,
          sectionId: sectionId,
          isCompany: isCompany,
        );
      },
    );
  }
}

/// Grid Item Widget
class _GridItemWidget extends StatelessWidget {
  final int id;
  final String name;
  final String? image;
  final int sectionId;
  final bool isCompany;

  const _GridItemWidget({
    required this.id,
    required this.name,
    required this.image,
    required this.sectionId,
    required this.isCompany,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle navigation or action
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: image != null
                        ? Image.asset(image!, fit: BoxFit.cover)
                        : const Icon(Icons.business, color: Colors.grey, size: 32),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: Constants.fontFamily),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
