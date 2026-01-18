import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String imageUrl;
  final String title;
  final String description;

  const OnboardingItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [imageUrl, title, description];
}