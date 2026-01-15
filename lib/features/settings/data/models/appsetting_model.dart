class AppSettingsModel {
  final int id;
  final String appName;
  final String androidVersion;
  final String iosVersion;
  final bool appOnOff;
  final String email;
  final String phone;
  final String? phone1;
  final String? phone2;
  final String? phone3;
  final String? phone4;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String address;
  final bool companyPaymentOn;
  final bool adsPaymentOn;
  final int carAdsLimit;
  final int propertyAdsLimit;
  final int technicianAdsLimit;
  final int anythingAdsLimit;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppSettingsModel({
    required this.id,
    required this.appName,
    required this.androidVersion,
    required this.iosVersion,
    required this.appOnOff,
    required this.email,
    required this.phone,
    this.phone1,
    this.phone2,
    this.phone3,
    this.phone4,
    this.facebook,
    this.twitter,
    this.linkedin,
    required this.address,
    required this.companyPaymentOn,
    required this.adsPaymentOn,
    required this.carAdsLimit,
    required this.propertyAdsLimit,
    required this.technicianAdsLimit,
    required this.anythingAdsLimit,
    this.createdAt,
    this.updatedAt,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    DateTime? _parseDate(String? v) {
      if (v == null) return null;
      try {
        return DateTime.tryParse(v);
      } catch (_) {
        return null;
      }
    }

    return AppSettingsModel(
      id: data['id'] ?? 0,
      appName: data['app_name'] ?? '',
      androidVersion: data['android_version'] ?? '',
      iosVersion: data['ios_version'] ?? '',
      appOnOff: data['app_on_off'] ?? true,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      phone1: data['phone1'],
      phone2: data['phone2'],
      phone3: data['phone3'],
      phone4: data['phone4'],
      facebook: data['facebook'],
      twitter: data['twitter'],
      linkedin: data['linkedin'],
      address: data['address'] ?? '',
      companyPaymentOn: data['company_payment_on'] == true,
      adsPaymentOn: data['ads_payment_on'] == true,
      carAdsLimit: data['car_ads_limit'] ?? 0,
      propertyAdsLimit: data['property_ads_limit'] ?? 0,
      technicianAdsLimit: data['technician_ads_limit'] ?? 0,
      anythingAdsLimit: data['anything_ads_limit'] ?? 0,
      createdAt: _parseDate(data['created_at']?.toString()),
      updatedAt: _parseDate(data['updated_at']?.toString()),
    );
  }

  List<String> phones() {
    return [phone, phone1, phone2, phone3, phone4]
        .whereType<String>()
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
  }

  /// Whether an update is required comparing current installed versions.
  /// Returns true if remote version is greater (lexicographically segmented by dots).
  bool isUpdateRequired({
    required String currentAndroid,
    required String currentIos,
    bool isAndroid = true,
  }) {
    final remote = (isAndroid ? androidVersion : iosVersion).trim();
    final local = (isAndroid ? currentAndroid : currentIos).trim();

    // لو واحد فيهم فاضي → لا تعمل Dialog
    if (remote.isEmpty || local.isEmpty) return false;

    // ✅ لو مختلفين → show dialog
    return remote != local;
  }

  AppSettingsModel copyWith({
    int? id,
    String? appName,
    String? androidVersion,
    String? iosVersion,
    bool? appOnOff,
    String? email,
    String? phone,
    String? phone1,
    String? phone2,
    String? phone3,
    String? phone4,
    String? facebook,
    String? twitter,
    String? linkedin,
    String? address,
    bool? companyPaymentOn,
    bool? adsPaymentOn,
    int? carAdsLimit,
    int? propertyAdsLimit,
    int? technicianAdsLimit,
    int? anythingAdsLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppSettingsModel(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      androidVersion: androidVersion ?? this.androidVersion,
      iosVersion: iosVersion ?? this.iosVersion,
      appOnOff: appOnOff ?? this.appOnOff,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      phone3: phone3 ?? this.phone3,
      phone4: phone4 ?? this.phone4,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      linkedin: linkedin ?? this.linkedin,
      address: address ?? this.address,
      companyPaymentOn: companyPaymentOn ?? this.companyPaymentOn,
      adsPaymentOn: adsPaymentOn ?? this.adsPaymentOn,
      carAdsLimit: carAdsLimit ?? this.carAdsLimit,
      propertyAdsLimit: propertyAdsLimit ?? this.propertyAdsLimit,
      technicianAdsLimit: technicianAdsLimit ?? this.technicianAdsLimit,
      anythingAdsLimit: anythingAdsLimit ?? this.anythingAdsLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'app_name': appName,
    'android_version': androidVersion,
    'ios_version': iosVersion,
    'app_on_off': appOnOff,
    'email': email,
    'phone': phone,
    'phone1': phone1,
    'phone2': phone2,
    'phone3': phone3,
    'phone4': phone4,
    'facebook': facebook,
    'twitter': twitter,
    'linkedin': linkedin,
    'address': address,
    'company_payment_on': companyPaymentOn,
    'ads_payment_on': adsPaymentOn,
    'car_ads_limit': carAdsLimit,
    'property_ads_limit': propertyAdsLimit,
    'technician_ads_limit': technicianAdsLimit,
    'anything_ads_limit': anythingAdsLimit,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsModel &&
        other.id == id &&
        other.appName == appName &&
        other.androidVersion == androidVersion &&
        other.iosVersion == iosVersion &&
        other.appOnOff == appOnOff &&
        other.email == email &&
        other.phone == phone &&
        other.phone1 == phone1 &&
        other.phone2 == phone2 &&
        other.phone3 == phone3 &&
        other.phone4 == phone4 &&
        other.facebook == facebook &&
        other.twitter == twitter &&
        other.linkedin == linkedin &&
        other.address == address &&
        other.companyPaymentOn == companyPaymentOn &&
        other.adsPaymentOn == adsPaymentOn &&
        other.carAdsLimit == carAdsLimit &&
        other.propertyAdsLimit == propertyAdsLimit &&
        other.technicianAdsLimit == technicianAdsLimit &&
        other.anythingAdsLimit == anythingAdsLimit &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    appName,
    androidVersion,
    iosVersion,
    appOnOff,
    email,
    phone,
    phone1,
    phone2,
    phone3,
    phone4,
    facebook,
    twitter,
    linkedin,
    address,
    companyPaymentOn,
    adsPaymentOn,
    carAdsLimit,
    propertyAdsLimit,
    technicianAdsLimit,
    anythingAdsLimit,
    createdAt,
    updatedAt,
  ]);
}
