import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class DescriptionCard extends StatelessWidget {
  final String description;
  final String? adId; // <-- NEW: رقم الإعلان

  const DescriptionCard({
    super.key,
    required this.description,
    this.adId, // <-- NEW
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0x11E53935), Color(0x112563EB)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
          border: Border.all(color: const Color(0x0F000000)),
        ),
        child: Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Header: عنوان + شارة رقم الإعلان =====
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.description_rounded,
                            size: 18,
                            color: Color(0xFF4B5563),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "الوصف",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (adId != null && adId!.trim().isNotEmpty)
                      _AdIdBadge(adId: adId!), // <-- NEW: شارة رقم الإعلان
                  ],
                ),

                const SizedBox(height: 10),

                // خط تحت العنوان (رفيع ومتدرج)
                Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0x12E53935),
                        Color(0x222563EB),
                        Color(0x12E53935),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),

                const SizedBox(height: 12),

                // صندوق النص
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFBFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      // شريط عمودي رفيع
                      Positioned.fill(
                        child: Align(
                          alignment: isRTL
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 3,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 23, 101, 196),
                                  Color.fromARGB(255, 11, 50, 136),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          isRTL ? 12 : 14,
                          12,
                          isRTL ? 14 : 12,
                          10,
                        ),
                        child: _ExpandableDescription(
                          text: description,
                          collapsedLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------------- شارة رقم الإعلان ---------------------- */

class _AdIdBadge extends StatelessWidget {
  final String adId;
  const _AdIdBadge({required this.adId});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8FAFF);
    const border = Color(0xFFE3E8FF);

    return Tooltip(
      message: "نسخ رقم الإعلان",
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: adId));
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم نسخ رقم الإعلان: $adId"),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.tag_rounded, size: 16, color: Color(0xFF3B5BDB)),
              const SizedBox(width: 6),
              // شكل مونو سبايس صغير وواضح
              Text(
                "#$adId",
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: Color(0xFF1F2A44),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.copy_rounded,
                size: 14,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableDescription extends StatefulWidget {
  final String text;
  final int collapsedLines;

  const _ExpandableDescription({required this.text, this.collapsedLines = 6});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;
  bool _overflow = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const textStyle = TextStyle(
        fontSize: 15.5,
        height: 1.75,
        color: Color.fromARGB(255, 190, 200, 213),
      );
      final tp = TextPainter(
        textDirection: Directionality.of(context),
        text: TextSpan(text: widget.text.trim(), style: textStyle),
        maxLines: widget.collapsedLines,
      );
      final maxWidth = context.size?.width ?? MediaQuery.of(context).size.width;
      tp.layout(maxWidth: maxWidth);
      if (mounted) setState(() => _overflow = tp.didExceedMaxLines);
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.text.trim().isEmpty
        ? "— لا يوجد وصف —"
        : widget.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Text(
            content,
            maxLines: _expanded ? null : widget.collapsedLines,
            style: TextStyle(
              fontSize: 16,
              height: 1.75,
              color: AppColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (_overflow) ...[
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                foregroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                size: 18,
              ),
              label: Text(_expanded ? "إظهار أقل" : "إظهار المزيد"),
            ),
          ),
        ],
      ],
    );
  }
}
