enum AccountType {
  company,
  individual,
}

class AccountTypeEntity {
  final AccountType type;
  final String title;
  final String subtitle;
  final String imageAsset;

  const AccountTypeEntity({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });
}
