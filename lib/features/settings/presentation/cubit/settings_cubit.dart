import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/app_storage_keys.dart';
import 'package:oreed_clean/features/settings/data/models/appsetting_model.dart';
import 'package:oreed_clean/features/settings/domain/repositories/settings_repo.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(const SettingsState());

  Future<void> loadSettings({
    String currentAndroid = '',
    String currentIos = '',
  }) async {
    emit(state.copyWith(status: SettingsStatus.loading, errorMessage: null));

    try {
      final settings = await repository.fetchSettings();

      bool needsUpdate = false;

      if (currentAndroid.isNotEmpty || currentIos.isNotEmpty) {
        needsUpdate = settings.isUpdateRequired(
          currentAndroid: currentAndroid,
          currentIos: currentIos,
          isAndroid: defaultTargetPlatform == TargetPlatform.android,
        );
      }

      _cacheSettings(settings);

      emit(
        state.copyWith(
          status: SettingsStatus.success,
          settings: settings,
          showUpdateBanner: needsUpdate,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _cacheSettings(AppSettingsModel s) async {
    final prefs = AppSharedPreferences();
    await prefs.setBool(AppStorageKeys.appOnOff, s.appOnOff == true);
    await prefs.setString(AppStorageKeys.androidVersion, s.androidVersion);
    await prefs.setString(AppStorageKeys.iosVersion, s.iosVersion);
    await prefs.setString(
      AppStorageKeys.lastUpdated,
      DateTime.now().toIso8601String(),
    );

    // Update local variables in the class
    prefs.appOnOff = s.appOnOff;
    prefs.cachedAndroidVersion = s.androidVersion;
    prefs.cachedIosVersion = s.iosVersion;
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool checkUpdateRequirement({
    required String android,
    required String ios,
    required bool isAndroid,
  }) {
    if (state.settings == null) return false;
    return state.settings!.isUpdateRequired(
      currentAndroid: android,
      currentIos: ios,
      isAndroid: isAndroid,
    );
  }
}
