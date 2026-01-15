part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, error }

class SettingsState extends Equatable {
  final AppSettingsModel? settings;
  final SettingsStatus status;
  final String? errorMessage;
  final bool showUpdateBanner;

  const SettingsState({
    this.settings,
    this.status = SettingsStatus.initial,
    this.errorMessage,
    this.showUpdateBanner = false,
  });

  // Derived getter for maintenance mode
  bool get isMaintenance {
    if (settings != null) {
      return settings!.appOnOff == false;
    }
    // Fallback to cached value
    return AppSharedPreferences().isAppOn == false;
  }

  SettingsState copyWith({
    AppSettingsModel? settings,
    SettingsStatus? status,
    String? errorMessage,
    bool? showUpdateBanner,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showUpdateBanner: showUpdateBanner ?? this.showUpdateBanner,
    );
  }

  @override
  List<Object?> get props => [settings, status, errorMessage, showUpdateBanner];
}
