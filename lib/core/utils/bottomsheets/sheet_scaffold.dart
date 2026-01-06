import 'package:flutter/material.dart';

class SheetScaffold extends StatelessWidget {
  final String title;
  final double heightFactor; // e.g., 0.85 or 0.45
  final int? selectedCount;
  final bool showCounter;
  final Widget body;
  final Widget footer;

  const SheetScaffold({
    super.key,
    required this.title,
    required this.heightFactor,
    required this.body,
    required this.footer,
    this.selectedCount,
    this.showCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: media.size.height * heightFactor,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const SheetHandle(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  if (showCounter && (selectedCount ?? 0) > 0)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${selectedCount!} محدد',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: Colors.white,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: body),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: footer,
            ),
          ],
        ),
      ),
    );
  }
}

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCBD5E1), Color(0xFFE2E8F0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
