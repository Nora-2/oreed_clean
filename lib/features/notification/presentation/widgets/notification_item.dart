import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/notification/data/models/notification_model.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Dismissible(
      key: ValueKey(notification.id),
      onDismissed: (d) {
        d == DismissDirection.endToStart
            ? cubit.deleteNotification(notification)
            : cubit.toggleRead(notification);
      },
      child: ListTile(
        onTap: () {
          if (!notification.isRead) cubit.toggleRead(notification);
        },
        title: Text(notification.title),
        subtitle: Text(notification.body),
        leading: notification.image == null
            ? null
            : CachedNetworkImage(
                imageUrl: notification.image!,
                width: 50,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
