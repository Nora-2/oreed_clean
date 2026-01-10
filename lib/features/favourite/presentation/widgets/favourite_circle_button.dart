import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';

class FavoriteCircleButton extends StatelessWidget {
  final int adId;
  final int sectionId;

  const FavoriteCircleButton({super.key, 
    required this.adId,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      // We only rebuild this specific button if its ID is in favoriteIds or pendingIds
      buildWhen: (previous, current) {
        final wasChanged = previous.favoriteIds.contains(adId) != current.favoriteIds.contains(adId);
        final pendingChanged = previous.pendingIds.contains(adId) != current.pendingIds.contains(adId);
        return wasChanged || pendingChanged;
      },
      builder: (context, state) {
        final isFav = state.favoriteIds.contains(adId);
        final isPending = state.pendingIds.contains(adId);

        return GestureDetector(
          onTap: isPending
              ? null
              : () async {
                  final result = await context.read<FavoritesCubit>().toggleFavorite(
                        sectionId: sectionId,
                        adId: adId,
                      );

                  // Show a message if the action failed (e.g., "Please login first")
                  if (!result.success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.messageKey)),
                    );
                  }
                },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffE8E8E9),
            ),
            child: isPending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1649D3)),
                    ),
                  )
                : Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFF1649D3),
                    size: 16,
                  ),
          ),
        );
      },
    );
  }
}