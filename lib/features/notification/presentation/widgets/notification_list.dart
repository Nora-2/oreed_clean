
import 'package:flutter/material.dart';
import 'package:oreed_clean/features/notification/data/models/notification_model.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:oreed_clean/features/notification/presentation/widgets/notification_ttile.dart';
import 'package:shimmer/shimmer.dart' as shimmer_pkg;
import 'package:url_launcher/url_launcher.dart';

class NotificationsList extends StatelessWidget {
  final NotificationsState state;
  final List<NotificationModel> items;
  final Future<void> Function() onRefresh;
  final Function(NotificationModel) onToggleRead;
  final Function(NotificationModel) onDelete;
  final ScrollController scrollController;

  const NotificationsList({super.key, 
    required this.state,
    required this.items,
    required this.onRefresh,
    required this.onToggleRead,
    required this.onDelete,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return _buildShimmer();
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(children: const [SizedBox(height: 100), Center(child: Text("No notifications"))]),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: items.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
        itemBuilder: (context, i) {
          if (i >= items.length) return const Center(child: CircularProgressIndicator());
          final n = items[i];
          return Dismissible(
            key: ValueKey(n.id),
            background: Container(color: Colors.green.withValues(alpha: 0.1), alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 20), child: const Icon(Icons.check, color: Colors.green)),
            secondaryBackground: Container(color: Colors.red.withValues(alpha: 0.1), alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.red)),
            onDismissed: (dir) => dir == DismissDirection.endToStart ? onDelete(n) : onToggleRead(n),
            child: NotificationTile(
              n: n,
              icon: _getIconForType(n.type),
              context: context,
              onTap: () {
                if (!n.isRead) onToggleRead(n);
                _handleNavigation(context, n);
              },
            ),
          );
        },
      ),
    );
  }
  String _getIconForType(String? type) {
  switch (type) {
    case 'personal': return 'assets/svg/personalnotfication.svg';
    case 'company': return 'assets/svg/volumnotification.svg';
    default: return 'assets/svg/notification.svg';
  }
}

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => shimmer_pkg.Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(leading: const CircleAvatar(), title: Container(height: 10, color: Colors.white), subtitle: Container(height: 10, color: Colors.white)),
      ),
    );
  }

  void _handleNavigation(BuildContext context, NotificationModel n) async {
    // Implement your navigation logic based on n.type
    if (n.type == 'phone' && n.phone != null) {
      launchUrl(Uri.parse('tel:${n.phone}'));
    } else if (n.type == 'personal' && n.adId != null) {
      // AppNavigator.navigateToAdDetails(context: context, adId: n.adId!, sectionId: n.sectionId ?? 1);
    }
  }
}