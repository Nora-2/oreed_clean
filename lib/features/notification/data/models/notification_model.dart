// Data model for notifications from API
class NotificationModel {
  final int id;
  final String title;
  final String body;
  final int read;
  final String? image;
  final String createdAt;

  // FCM metadata fields for navigation
  final String? type; // 'personal', 'company', or 'phone'
  final int? adId; // for personal ads
  final int? companyId; // for company notifications
  final int? sectionId; // for both personal and company
  final String? phone; // for phone calls
  final String? rawValue;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
    this.image,
    required this.createdAt,
    this.type,
    this.adId,
    this.companyId,
    this.sectionId,
    this.phone,
    this.rawValue,
  });

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    return int.tryParse(v.toString());
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'normal';
    final rawValue = json['values'] as String? ?? json['value'] as String?;
    final sectionId =
        json['section_id'] != null ? _parseInt(json['section_id']) : null;

    final personalAdId = type == 'personal' ? _parseInt(rawValue) : null;
    final companyId = type == 'company' ? _parseInt(rawValue) : null;
    final phoneValue = type == 'phone' ? rawValue : null;

    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      read: json['read'] as int? ?? 0,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      type: type,
      adId: personalAdId,
      companyId: companyId,
      sectionId: sectionId,
      phone: phoneValue,
      rawValue: rawValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'read': read,
      'image': image,
      'created_at': createdAt,
      'type': type,
      'ad_id': adId,
      'company_id': companyId,
      'section_id': sectionId,
      'phone': phone,
      'values': rawValue,
    };
  }

  bool get isRead => read == 1;

  DateTime? get createdAtDate {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }
}

class NotificationsResponse {
  final int code;
  final bool status;
  final String msg;
  final List<NotificationModel> data;
  final PaginationModel pagination;

  NotificationsResponse({
    required this.code,
    required this.status,
    required this.msg,
    required this.data,
    required this.pagination,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      code: json['code'] as int? ?? 200,
      status: json['status'] as bool? ?? false,
      msg: json['msg'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }

  bool get hasNextPage => nextPageUrl != null && nextPageUrl!.isNotEmpty;

  bool get hasPrevPage => prevPageUrl != null && prevPageUrl!.isNotEmpty;
}
