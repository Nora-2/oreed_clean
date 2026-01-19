class PropertyResponseEntity {
  final bool status;
  final String msg;
  final int? id;

  const PropertyResponseEntity({
    required this.status,
    required this.msg,
    this.id,
  });
}
