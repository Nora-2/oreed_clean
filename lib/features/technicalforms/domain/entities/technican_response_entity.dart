class TechnicianResponseEntity {
  final bool status;
  final String msg;
  final int? id;

  const TechnicianResponseEntity({
    required this.status,
    required this.msg,
    this.id,
  });
}