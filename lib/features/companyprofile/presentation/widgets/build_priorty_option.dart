import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
// Import your cubit file
// import 'package:your_app/cubits/company_profile_cubit.dart';

class BuildPriorityOption extends StatelessWidget {
  const BuildPriorityOption({
    super.key,
    required this.isUpdatingPriority,
    required this.priority,
    required this.companyId,
    required this.titleAr,
    required this.subtitleAr,
    required this.icon,
    required this.color,
    required this.badgeColor,
    required this.adId,
    required this.sectionId,
  });

  final bool isUpdatingPriority;
  final int priority;
  final int companyId;
  final String titleAr;
  final String subtitleAr;
  final IconData icon;
  final Color color;
  final Color badgeColor;
  final String? adId;
  final int sectionId;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Disable tap if global state is loading
        onTap: isUpdatingPriority
            ? null
            : () async {
                // 1. Capture messenger before popping context
                final messenger = ScaffoldMessenger.of(context);

                // 2. Get the Cubit
                final cubit = context.read<CompanyprofileCubit>();

                // 3. Close the bottom sheet/dialog
                Navigator.pop(context);

                // 4. Trigger the Cubit action
                // Note: It's better to let the Cubit handle the API call.
                // If your Cubit returns the result directly:
                final result = await cubit.updateAdPriority(
                  sectionId: sectionId,
                  adId: int.tryParse(adId ?? '0') ?? 0,
                  priority: priority,
                  companyId: companyId,
                );

                // 5. Handle UI feedback
                if (result != null) {
                  final bool success = result['success'] == true;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ?? (success ? 'Success' : 'Failed'),
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            borderRadius: BorderRadius.circular(14),
            color: badgeColor.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              // Icon Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isUpdatingPriority
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        )
                      : Icon(icon, color: color, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleAr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitleAr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
