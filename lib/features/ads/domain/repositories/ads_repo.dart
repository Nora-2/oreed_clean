
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';

abstract class AdsRepository {
  Future<DeleteAdResult> deleteCar(int adId);
  Future<DeleteAdResult> deleteProperty(int adId);
  Future<DeleteAdResult> deleteTechnician(int adId);
  Future<DeleteAdResult> deleteAnything(int adId, int sectionId);
}
