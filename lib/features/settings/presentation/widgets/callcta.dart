import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class _CallCTA extends StatefulWidget {
  final String number;
  final VoidCallback onCall;

  const _CallCTA({required this.number, required this.onCall});

  @override
  State<_CallCTA> createState() => _CallCTAState();
}

class _CallCTAState extends State<_CallCTA>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // إطار متدرّج رفيع يلف الزر
    return Semantics(
      button: true,
      label: '  ${widget.number}',
      child: Tooltip(
        message:
            '${AppTranslations.of(context)!.text('tap_to_call')} • ${AppTranslations.of(context)!.text('tap_and_hold_to_copy')}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(1.4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF25D366).withValues(alpha: 0.85),
                // WhatsApp green-ish
                const Color(0xFF128C7E).withValues(alpha: 0.85),
              ],
            ),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        109,
                        199,
                        109,
                      ).withValues(alpha: 0.20),
                      blurRadius: 7,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onHighlightChanged: (v) => setState(() => _pressed = v),
              onTap: widget.onCall,
              onLongPress: () async {
                await Clipboard.setData(ClipboardData(text: widget.number));
                Fluttertoast.showToast(
                  msg: AppTranslations.of(context)!.text('number_copied'),
                );
                HapticFeedback.selectionClick();
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 14, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // كبسولة الأيقونة
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.call_rounded,
                        size: 18,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // الرقم
                    Text(
                      widget.number,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
