class CarResponseEntity {
  final bool status;
  final String msg;
  final int? id;

  const CarResponseEntity({
    required this.status,
    required this.msg,
    this.id,
  });
}