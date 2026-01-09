
class AdvancedSearchResponse {
  final int code;
  final bool status;
  final String msg;
  final List<SearchSection> data;
  final PaginationInfo? pagination;

  AdvancedSearchResponse({
    required this.code,
    required this.status,
    required this.msg,
    required this.data,
    this.pagination,
  });

  factory AdvancedSearchResponse.fromJson(Map<String, dynamic> json) {
    return AdvancedSearchResponse(
      code: json['code'] ?? 200,
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => SearchSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'msg': msg,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

/// Search section (e.g., "السيارات", "العقارات")
class SearchSection {
  final String name;
  final int companyCount;
  final int categoryCount;
  final int sectionId;
  final List<CompanySearchResult> companies;
  final List<CategorySearchResult> categories;

  SearchSection({
    required this.name,
    required this.companyCount,
    required this.sectionId,
    required this.categoryCount,
    required this.companies,
    required this.categories,
  });

  bool get hasResults => companyCount > 0 || categoryCount > 0;

  factory SearchSection.fromJson(Map<String, dynamic> json) {
    return SearchSection(
      name: json['name'] ?? '',
      sectionId: json['section_id'] ?? 0,
      companyCount: json['company_count'] ?? 0,
      categoryCount: json['category_count'] ?? 0,
      companies: (json['companies'] as List<dynamic>?)
              ?.map((e) =>
                  CompanySearchResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) =>
                  CategorySearchResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company_count': companyCount,
      'category_count': categoryCount,
      'companies': companies.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

/// Company result in search
class CompanySearchResult {
  final int id;
  final String name;
  final int count;

  CompanySearchResult({
    required this.id,
    required this.name,
    required this.count,
  });

  factory CompanySearchResult.fromJson(Map<String, dynamic> json) {
    return CompanySearchResult(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}

/// Category result in search
class CategorySearchResult {
  final int id;
  final String name;
  final int count;

  CategorySearchResult({
    required this.id,
    required this.name,
    required this.count,
  });

  factory CategorySearchResult.fromJson(Map<String, dynamic> json) {
    return CategorySearchResult(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}

/// Pagination info
class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  bool get hasNextPage => nextPageUrl != null && nextPageUrl!.isNotEmpty;
  bool get hasPrevPage => prevPageUrl != null && prevPageUrl!.isNotEmpty;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
    };
  }
}

