class LocalType {
  final String? id;
  final String? titleAr;
  final String? titleEn;
  final String? type;

  LocalType({this.id, this.titleAr, this.titleEn, this.type});

  LocalType copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? type,
  }) => LocalType(
    id: id ?? this.id,
    titleAr: titleAr ?? this.titleAr,
    titleEn: titleEn ?? this.titleEn,
    type: type ?? this.type,
  );

  @override
  String toString() {
    return '''
    id: $id
    title: $titleAr
    type: $type
    ''';
  }
}
