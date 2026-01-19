import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ad_card_newlook.dart';

class Navigationedit extends StatelessWidget {
  const Navigationedit({super.key, required this.widget});

  final AdCardNewLook widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SvgPicture.asset(AppIcons.edit),
      onTap: () async {
        // push the appropriate form and wait for result.
        Object? result;
        if (widget.sectionType == 'technician') {
          result = await Navigator.pushNamed(
            context,
            Routes.technicanform,
            arguments: {'sectionID': widget.sectionId,
              'categoryId': 0,
              'adId': int.tryParse(widget.adId!),}

          );
        } else if (widget.sectionType ==
            'property') {
            result = await Navigator.pushNamed(
              context,
              Routes.realstateform,
              arguments: {'sectionId': 0,
                  'categoryId': 0,
                  'adId': int.tryParse(widget.adId!),
                  'supCategoryId': 0,}

            );
          }
        // else if (widget.sectionType == 'car') {
        //   result = await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => CarFormUI(
        //         sectionId: 0,
        //         categoryId: 0,
        //         adId: int.tryParse(widget.adId!),
        //         supCategoryId: 0,
        //       ),
        //     ),
        //   );
        // } else {
        //   result = await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => AnythingForm(
        //         sectionId: widget.sectionId,
        //         categoryId: 0,
        //         adId: int.tryParse(widget.adId!),
        //         supCategoryId: 0,
        //       ),
        //     ),
        //   );
        // }

        // If the pushed screen returned `true`, notify parent via onEdit
        if (result == true) {
          try {
            if (widget.onEdit != null) {
              widget.onEdit!();
            }
          } catch (_) {}
        }
      },
    );
  }
}
