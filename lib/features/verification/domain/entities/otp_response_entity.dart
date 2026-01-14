class OtpResponseEntity {
  final bool status;
  final String msg;
  final Map data;
  final int id;

  const OtpResponseEntity({
    required this.status,
    required this.msg,
    required this.data,
    required this.id,
  });
}
