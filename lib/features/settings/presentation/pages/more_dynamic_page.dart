import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/features/settings/data/models/page_model.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/more_dynamic_page_map.dart';
class MoreDynamicPage extends StatefulWidget {

  final PageModel? pageModel;

  const MoreDynamicPage({super.key, this.pageModel});

  @override
  State<MoreDynamicPage> createState() => _MoreDynamicPageState();
}

class _MoreDynamicPageState extends State<MoreDynamicPage> {

  @override
  Widget build(BuildContext context) {
 
    final title = widget.pageModel?.title?.trim() ?? "";
    final descriptionHtml = (widget.pageModel?.description ?? "").trim();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A2332) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        leadingWidth: 64,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: Center(
        //       child: Icon(icon, color: Colors.black, size: 24),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 🎨 App Logo Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Logo Container
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Image(
                          image: AssetImage(Appimage.logo))),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // 📄 Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Html(
                  data: descriptionHtml.isEmpty
                      ? "<div style='text-align: center; color: #999;'><p>لا يوجد محتوى</p></div>"
                      : descriptionHtml,
                  style: getHtmlStyles(textColor, isDark),
                  onLinkTap: (url, attributes, element) {
                    // Future: Add link opening functionality
                    debugPrint('Link tapped: $url');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
