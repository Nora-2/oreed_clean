// ignore_for_file: unused_element_parameter
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/ad_type_badge.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/imageback.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/navigationto.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/periorty_menu.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/personal_free_widget.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/priorty_bottom_sheet.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/priorty_button.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/status_ship.dart';

class AdCardNewLook extends StatefulWidget {
  final String title;
  final String type;
  final String date;
  final int views;
  final int sectionId;
  final int companyId;
  final String? status;
  final String? adType;
  final String? adId;
  final String? sectionType;
  final String? imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRepublish;
  final bool showHighlight;
  final bool showPin;
  final String ownerType;

  const AdCardNewLook({
    super.key,

    required this.title,
    required this.adId,
    required this.ownerType,
    required this.sectionType,
    required this.type,
    required this.adType,
    required this.companyId,
    required this.date,
    required this.views,
    required this.sectionId,
    this.status,
    this.imageUrl,
    this.onEdit,
    this.onDelete,
    this.onRepublish,
    this.showHighlight = true,
    this.showPin = true,
  });

  @override
  State<AdCardNewLook> createState() => AdCardNewLookState();
}

class AdCardNewLookState extends State<AdCardNewLook> {
  final bool _isUpdatingPriority = false;

  void showPriorityWorkflow(BuildContext context, int companyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PriorityBottomSheet(companyId: companyId),
    );
  }

  void _showPriorityMenu() {
    if (_isUpdatingPriority) return;
    AppTranslations t = AppTranslations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Priortymenu(
          t: t,
          isUpdatingPriority: _isUpdatingPriority,
          widget: widget,
        ),
      ),
    );
  }

  bool _isExpired(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;

    try {
      // Try parsing the date (supports both with/without time)
      final expiry = DateTime.tryParse(dateString);
      if (expiry == null) return false;

      final now = DateTime.now();
      return expiry.isBefore(now);
    } catch (e) {
      // If parsing fails, assume not expired to avoid false positives
      return false;
    }
  }

  String _formatDateOnly(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final dateTime = DateTime.tryParse(dateString);
      if (dateTime == null) return dateString;

      // Format as YYYY-MM-DD
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    final s = (widget.status ?? '').trim();
    final bool isExpired = _isExpired(widget.date);

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xffE8E8E9)),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.addetails,
                  arguments: {
                    'sectionId': widget.sectionId,
                    'adId': int.tryParse(widget.adId!)!,
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth;
                    final infoWidth =
                        cardWidth * 0.60; // area for title / info pills
                    final typeWidth = cardWidth * 0.60;

                    return Stack(
                      children: [
                        // الخلفية (صورة)
                        Positioned.fill(child: ImageBack(widget: widget)),

                        // تدرّج فوق الصورة
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.05),
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                          ),
                        ),
                        widget.adType != 'free'
                            ? PositionedDirectional(
                                top: 10,
                                start: 8,
                                // left: isRTL ? 0 : 8,
                                child: AdTypeBadge(
                                  type: adTypeFromString(widget.adType),
                                  dense: true,
                                ),
                              )
                            : Positioned(top: 0, right: 2, child: Container()),
                        if (widget.status != null &&
                            widget.status!.trim().isNotEmpty)
                          PositionedDirectional(
                            start: 8,
                            // left: isRTL ? 0 : 8,
                            top: widget.adType == 'free' ? 8 : 38,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Align(
                                alignment: isRTL
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: StatusChip(
                                  status: isExpired ? 'Expired' : s,
                                  date: widget.date,
                                ),
                              ),
                            ),
                          ),

                        PositionedDirectional(
                          end: 8,
                          // right: isRTL ? 12 : 0,
                          top: 12,
                          child: Row(
                            children: [
                              widget.ownerType == 'personal'
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        // showPriorityWorkflow(context, widget.companyId);
                                        _showPriorityMenu();
                                      },
                                      child: PriorityButton(
                                        isLoading: _isUpdatingPriority,
                                        onTap: () {
                                          _showPriorityMenu();
                                        },
                                      ),
                                    ),
                              const SizedBox(width: 5),
                              if (widget.onEdit != null) ...[
                                Navigationedit(widget: widget),
                              ],
                              const SizedBox(width: 5),
                              if (widget.onDelete != null)
                                GestureDetector(
                                  onTap: widget.onDelete ?? () {},
                                  child: SvgPicture.asset(
                                    AppIcons.deleteWithBackGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // العنوان + التاريخ + المشاهدات (يمين أسفل)
                        Positioned(
                          right: isRTL ? 14 : 0,
                          left: isRTL ? 0 : 14,
                          bottom: 12,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: isRTL
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: infoWidth,
                                ),
                                child: Text(
                                  widget.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InfoPill(
                                    icon: AppIcons.loadingTime,
                                    label: _formatDateOnly(widget.date),
                                  ),
                                  const SizedBox(width: 8),
                                  InfoPill(
                                    icon: AppIcons.eyeActive,
                                    label: '${widget.views}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // نوع الإعلان (قبل العنوان بقليل، أعلى منه)
                        Positioned(
                          right: (isRTL ? 14 : 0),
                          left: (isRTL ? 0 : 14),
                          bottom: 66,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: typeWidth),
                            child: Text(
                              widget.type,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          widget.ownerType == 'personal'
              ? const SizedBox(height: 12)
              : Container(),
          // SizedBox(height: 10,),
          (widget.ownerType == 'personal' && widget.adType == 'free')
              ? PersonalFreeActions(t: t, widget: widget)
              : Container(),
        ],
      ),
    );
  }
}
