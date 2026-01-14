import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/addetails/data/models/favourie_ad_model.dart';
import 'package:oreed_clean/features/addetails/presentation/cubit/saved_ads_state.dart';

class SavedAdsCubit extends Cubit<SavedAdsState> {
  SavedAdsCubit() : super(const SavedAdsState());

  void add(FavoriteAd ad) {
    final newItems = Map<String, FavoriteAd>.from(state.items)..[ad.id] = ad;

    emit(SavedAdsState(items: newItems));
  }

  void remove(String id) {
    if (!state.items.containsKey(id)) return;

    final newItems = Map<String, FavoriteAd>.from(state.items)..remove(id);

    emit(SavedAdsState(items: newItems));
  }

  void toggle(FavoriteAd ad) {
    final newItems = Map<String, FavoriteAd>.from(state.items);

    if (newItems.containsKey(ad.id)) {
      newItems.remove(ad.id);
    } else {
      newItems[ad.id] = ad;
    }

    emit(SavedAdsState(items: newItems));
  }

  bool isSaved(String id) => state.isSaved(id);

  List<FavoriteAd> latest(int count) => state.latest(count);
}
