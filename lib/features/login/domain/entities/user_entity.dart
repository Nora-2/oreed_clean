class UserEntity {
  final int id;
  final String name;
  final String phone;
  final String accountType;
  final String? token;
  final String? companyId;

  UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.accountType,
    required this.companyId,
    this.token,
  });
}
