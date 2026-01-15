import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_ad_use_case.dart';
import 'package:oreed_clean/features/companyprofile/data/models/delete_ad_result.dart';
import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import 'package:oreed_clean/features/companyprofile/domain/usecases/get_company_profile_ad_usecase.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../../domain/entities/company_profile_entity.dart';
import '../../domain/usecases/get_company_profile_usecase.dart';

part 'companyprofile_state.dart';

class CompanyprofileCubit extends Cubit<CompanyprofileState> {
  final GetCompanyProfileUseCase getCompanyProfileUseCase;
  final GetCompanyProfileAdsUseCase getCompanyAdsUseCase;
  final DeleteAdUseCase deleteAdUseCase;

  CompanyprofileCubit(
    this.getCompanyProfileUseCase,
    this.getCompanyAdsUseCase,
    this.deleteAdUseCase,
  ) : super(const CompanyprofileState());

  /// 🚀 Fetch profile + first ads page
  Future<void> fetchCompanyProfileAndAds(int companyId) async {
    emit(
      state.copyWith(status: CompanyProfileStatus.loading, errorMessage: null),
    );

    try {
      final profile = await getCompanyProfileUseCase(companyId);

      emit(state.copyWith(profile: profile));

      await fetchCompanyAds(
        companyId: profile.userId,
        sectionId: profile.sectionId,
        loadMore: false,
      );

      emit(state.copyWith(status: CompanyProfileStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CompanyProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// 📦 Fetch ads (pagination)
  Future<void> fetchCompanyAds({
    required int companyId,
    required int sectionId,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      emit(state.copyWith(ads: [], currentPage: 1, hasMore: true));
    }

    if (!state.hasMore) return;

    try {
      final newAds = await getCompanyAdsUseCase(
        companyId: companyId,
        sectionId: sectionId,
        page: state.currentPage,
      );

      emit(
        state.copyWith(
          ads: [...state.ads, ...newAds],
          currentPage: state.currentPage + 1,
          hasMore: newAds.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// 🗑️ Delete Ad
  Future<DeleteAdResult> deleteAd({
    required int adId,
    required int sectionId,
  }) async {
    try {
      final result = await deleteAdUseCase(adId: adId, sectionId: sectionId);

      if (result.success) {
        emit(
          state.copyWith(ads: state.ads.where((ad) => ad.id != adId).toList()),
        );
      }

      return result;
    } catch (e) {
      return DeleteAdResult(success: false, message: e.toString());
    }
  }

  /// 🎯 Update ad priority
  Future<Map<String, dynamic>> updateAdPriority({
    required int adId,
    required int sectionId,
    required int companyId,
    required int priority,
  }) async {
    try {
      final prefs = AppSharedPreferences();
      await prefs.initSharedPreferencesProp();

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.userToken}',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiProvider.baseUrl}/api/v1/update_priority'),
      );

      request.fields.addAll({
        'section_id': sectionId.toString(),
        'company_id': companyId.toString(),
        'ad_id': adId.toString(),
        'priority': priority.toString(),
      });

      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final json = jsonDecode(body);

        return {'success': true, 'message': json['msg'], 'data': json['data']};
      }

      return {'success': false, 'message': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
