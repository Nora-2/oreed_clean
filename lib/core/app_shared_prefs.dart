// lib/utils/app_shared_prefs.dart
import 'package:oreed_clean/features/login/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_storage_keys.dart';

class AppSharedPreferences {
  static final AppSharedPreferences _appSharedPreferences =
      AppSharedPreferences._internal();

  factory AppSharedPreferences() => _appSharedPreferences;

  AppSharedPreferences._internal();

  late SharedPreferences _sharedPreferences;

  // keys
  static const String _kIsLoggedIn = 'is_logged_in';
// ---------- App Settings Cache ----------
  bool? appOnOff;
  String? cachedAndroidVersion;
  String? cachedIosVersion;
  // cached properties (initialized in initSharedPreferencesProp)
  String? userToken;
  int? companyId;
  int? userId;
  String? userName;
  String? userNameAr;
  String? userType;
  String? userAbout;
  String? userImage;
  String? userPhone;

  String? languageCode;
  bool? checkFirst;
  bool? allowNotification;
  bool? isAdmin;
  int countryId = 1;
  String? countryCode;
  bool isLoggedIn = false;
// ---------- App Settings Getters ----------

  bool get isAppOn => appOnOff ?? true;

  String? get androidVersionCached => cachedAndroidVersion;

  String? get iosVersionCached => cachedIosVersion;

  /// Must be called once (e.g. in main) before using sync getters
  Future initSharedPreferencesProp() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initAppSetting();
    _initUserData();
    _initCachedSettings(); // ✅ جديد

    return userName;
  }
  void _initCachedSettings() {
    appOnOff =
        _sharedPreferences.getBool(AppStorageKeys.appOnOff) ?? true;

    cachedAndroidVersion =
        _sharedPreferences.getString(AppStorageKeys.androidVersion);

    cachedIosVersion =
        _sharedPreferences.getString(AppStorageKeys.iosVersion);
  }

// ---------- App Settings Cache Helpers ----------

  Future<void> saveAppSettingsCache({
    required bool appOnOff,
    required String androidVersion,
    required String iosVersion,
  }) async {
    this.appOnOff = appOnOff;
    cachedAndroidVersion = androidVersion;
    cachedIosVersion = iosVersion;

    await _sharedPreferences.setBool(
      AppStorageKeys.appOnOff,
      appOnOff,
    );

    await _sharedPreferences.setString(
      AppStorageKeys.androidVersion,
      androidVersion,
    );

    await _sharedPreferences.setString(
      AppStorageKeys.iosVersion,
      iosVersion,
    );

    await _sharedPreferences.setString(
      AppStorageKeys.lastUpdated,
      DateTime.now().toIso8601String(),
    );
  }

  void _initAppSetting() {
    // Read onboarding flag without rewriting it so we don't accidentally reset it.
    checkFirst = _sharedPreferences.getBool(AppStorageKeys.checkFirst);

    allowNotification =
        _sharedPreferences.getBool(AppStorageKeys.allowNotification) ?? false;
    _sharedPreferences.setBool(
        AppStorageKeys.allowNotification, allowNotification!);

    languageCode =
        _sharedPreferences.getString(AppStorageKeys.languageCode) ?? 'ar';
    _sharedPreferences.setString(AppStorageKeys.languageCode, languageCode!);

    isAdmin = (_sharedPreferences.getBool(AppStorageKeys.isAdmin));
    if (isAdmin != null) {
      _sharedPreferences.setBool(AppStorageKeys.isAdmin, isAdmin!);
    }
  }

  void _initUserData() {
    userToken = _sharedPreferences.getString(AppStorageKeys.token);
    companyId = _sharedPreferences.getInt('companyId');
    userId = _sharedPreferences.getInt(AppStorageKeys.userId);
    userName = _sharedPreferences.getString(AppStorageKeys.userName);
    userNameAr = _sharedPreferences.getString(AppStorageKeys.userNameAr);
    userType = _sharedPreferences.getString(AppStorageKeys.userType);
    userImage = _sharedPreferences.getString(AppStorageKeys.userImage);
    userPhone = _sharedPreferences.getString(AppStorageKeys.userPhone);
    countryCode = _sharedPreferences.getString(AppStorageKeys.countryCode);

    // ✅ لو flag مش موجود / غلط → اعتبر الدخول من وجود التوكن
    final savedFlag = _sharedPreferences.getBool(_kIsLoggedIn);
    final hasToken = (userToken != null && userToken!.isNotEmpty);

    isLoggedIn = savedFlag ?? hasToken;

    // ✅ لو عندي توكن بس الفلاج false → صححها مرة واحدة
    if (hasToken && savedFlag != true) {
      _sharedPreferences.setBool(_kIsLoggedIn, true);
    }
  }

  // ---------- Accessors / helpers ----------

  /// Synchronous getter for userId (may be null if init not called yet)
  int? get getUserId => userId;

  /// Synchronous getter for language (may be null if init not called yet)
  String? get getLanguageCode => languageCode;

  /// Synchronous getter for token
  String? get getUserToken => userToken;

  int? get getCompanyId => companyId;

  /// Synchronous getter for logged in flag
  bool get getIsLoggedIn => isLoggedIn;

  // ---------- simple wrappers for single prefs ----------

  Future<bool> getPolicyApproval() async {
    return _sharedPreferences.getBool('agreed_policy') ?? false;
  }

  Future<void> setPolicyApproval(bool value) async {
    await _sharedPreferences.setBool('agreed_policy', value);
  }

  int? getUserIdD() {
    return _sharedPreferences.getInt(AppStorageKeys.userId);
  }

  Future<void> saveAppLang(String langCode) async {
    languageCode = langCode;
    await _sharedPreferences.setString(AppStorageKeys.languageCode, langCode);

    // mark that user passed the first-time flow
    checkFirst = true;
    bool? savedcheckFirst =
        _sharedPreferences.getBool(AppStorageKeys.checkFirst);

    if (savedcheckFirst == false) {
      await _sharedPreferences.setBool(AppStorageKeys.checkFirst, true);
    }
  }

  Future<void> saveAllowNotification(bool value) async {
    allowNotification = value;
    await _sharedPreferences.setBool(
        AppStorageKeys.allowNotification, allowNotification!);
  }

  Future<void> saveCheckFirst(bool isFirst) async {
    checkFirst = isFirst;
    await _sharedPreferences.setBool(AppStorageKeys.checkFirst, isFirst);
  }

  Future<void> saveIsAdmin(bool isadmin) async {
    isAdmin = isadmin;
    await _sharedPreferences.setBool(AppStorageKeys.isAdmin, isadmin);
  }

  Future<void> saveUserToken(String token) async {
    userToken = token;
    await _sharedPreferences.setString(AppStorageKeys.token, token);
  }

  Future<void> saveCompanyId(int id) async {
    companyId = id;
    await _sharedPreferences.setInt('companyId', id);
  }

  Future<void> saveUserId(int id) async {
    userId = id;
    await _sharedPreferences.setInt(AppStorageKeys.userId, id);
  }

  Future<void> saveUserName(String name) async {
    userName = name;
    await _sharedPreferences.setString(AppStorageKeys.userName, name);
  }

  Future<void> saveUserNameAr(String name) async {
    userNameAr = name;
    await _sharedPreferences.setString(AppStorageKeys.userNameAr, name);
  }

  Future<void> saveUserType(String type) async {
    userType = type;
    await _sharedPreferences.setString(AppStorageKeys.userType, type);
  }

  Future<void> saveuserImage(String image) async {
    userImage = image;
    await _sharedPreferences.setString(AppStorageKeys.userImage, image);
  }

  Future<void> saveuserPhone(String phone) async {
    userPhone = phone;
    await _sharedPreferences.setString(AppStorageKeys.userPhone, phone);
  }

  /// Fix: avoid shadowing the field name
  Future<void> saveCountryCode(String code) async {
    countryCode = code;
    await _sharedPreferences.setString(AppStorageKeys.countryCode, code);
  }

  // Future<void> saveUserdata({UserModel? user, String? token}) async {
  //   if (user != null) {
  //     userId = user.id;
  //     userName = user.name?.en;
  //     userNameAr = user.name?.ar;
  //     userPhone = user.phone1;
  //     userType = user.type;
  //     await _sharedPreferences.setString(
  //         AppStorageKeys.userType, userType ?? '');
  //     if (userId != null) {
  //       await _sharedPreferences.setInt(AppStorageKeys.userId, userId!);
  //     }
  //     if (userName != null) {
  //       await _sharedPreferences.setString(AppStorageKeys.userName, userName!);
  //     }
  //     if (userNameAr != null) {
  //       await _sharedPreferences.setString(
  //           AppStorageKeys.userNameAr, userNameAr!);
  //     }
  //     if (userPhone != null) {
  //       await _sharedPreferences.setString(
  //           AppStorageKeys.userPhone, userPhone!);
  //     }
  //   }

  //   if (token != null) {
  //     userToken = token;
  //     await _sharedPreferences.setString(AppStorageKeys.token, token);
  //   }
  // }

  // ---------- logged-in flag helpers ----------

  Future<void> saveLoggedIn(bool value) async {
    isLoggedIn = value;
    await _sharedPreferences.setBool(_kIsLoggedIn, value);
  }

  Future<bool> isLoggedInAsync() async {
    return _sharedPreferences.getBool(_kIsLoggedIn) ?? false;
  }

  // ---------- Generic helpers for any key ----------

  bool getBool(String key, {bool defaultValue = false}) {
    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  // ---------- clear ----------

  void clearPrefs() {
    String? savedLanguageCode = languageCode;

    _sharedPreferences.clear();

    languageCode = savedLanguageCode;
    _sharedPreferences.setString(AppStorageKeys.languageCode, languageCode!);

    userToken = '';
    userId = 0;
    userName = '';
    userNameAr = '';
    userType = '';
    userAbout = '';
    userImage = '';
    userPhone = '';
    isLoggedIn = false;
  }

  bool get hasSeenOnboarding => checkFirst ?? false;

  /// Synchronous getter that reads the onboarding flag directly from prefs.
  bool get hasSeenOnboardingSync =>
      _sharedPreferences.getBool(AppStorageKeys.checkFirst) ?? false;

  /// Convenience helper to decide if onboarding should be shown.
  bool get shouldShowOnboarding => !(checkFirst ?? false);

  Future<void> markOnboardingSeen() => saveCheckFirst(true);
}
