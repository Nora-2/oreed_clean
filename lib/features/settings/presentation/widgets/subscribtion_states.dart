/// Domain entity representing subscription status
class SubscriptionStatus {
  final DateTime? expiryDate;
  final bool isExpired;
  final int daysLeft;

  const SubscriptionStatus({
    this.expiryDate,
    required this.isExpired,
    required this.daysLeft,
  });

  /// Factory constructor to create from date string
  factory SubscriptionStatus.fromDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return const SubscriptionStatus(
        expiryDate: null,
        isExpired: false,
        daysLeft: 0,
      );
    }

    final expiry = DateTime.tryParse(dateString);
    if (expiry == null) {
      return const SubscriptionStatus(
        expiryDate: null,
        isExpired: false,
        daysLeft: 0,
      );
    }

    final now = DateTime.now();
    final isExpired = expiry.isBefore(now);
    final difference = expiry.difference(now);
    final daysLeft = isExpired ? 0 : difference.inDays;

    return SubscriptionStatus(
      expiryDate: expiry,
      isExpired: isExpired,
      daysLeft: daysLeft,
    );
  }

  /// Format date for display
  String formatDate() {
    if (expiryDate == null) return '';
    return '${expiryDate!.year}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}';
  }
}
