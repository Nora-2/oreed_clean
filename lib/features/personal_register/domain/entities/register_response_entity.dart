class RegisterResponseEntity {
  final bool status;
  final String msg;
  final int code;

  const RegisterResponseEntity({
    required this.status,
    required this.msg,
    required this.code,
  });
}