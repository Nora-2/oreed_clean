import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/addetails/data/models/favourie_ad_model.dart';

class SavedAdsState extends Equatable {
  final Map<String, FavoriteAd> items;

  const SavedAdsState({this.items = const {}});

  List<FavoriteAd> get list => items.values.toList(growable: false);

  bool isSaved(String id) => items.containsKey(id);

  List<FavoriteAd> latest(int count) {
    return list.reversed.take(count).toList();
  }

  @override
  List<Object> get props => [items];
}
