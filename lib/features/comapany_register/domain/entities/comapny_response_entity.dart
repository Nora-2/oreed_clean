class CompanyResponseEntity {
  final bool status;
  final String msg;
  final int? id;

  const CompanyResponseEntity({
    required this.status,
    required this.msg,
    this.id,
  });
}