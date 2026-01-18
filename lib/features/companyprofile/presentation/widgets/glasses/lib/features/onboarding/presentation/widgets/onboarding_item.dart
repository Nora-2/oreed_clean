import 'package:glasses/core/utils/appimage/app_images.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/features/onboarding/data/models/on_boardingmodel.dart';

final List<OnboardingItem> onboardingPages =  [
    OnboardingItem(
      imageUrl: Appimage.onboarding1,
      title: Appstring.onaboardingtitel1,
      description:Appstring.onaboardingdescription1,
    ),
    OnboardingItem(
      imageUrl: Appimage.onboarding2,
     title: Appstring.onaboardingtitel2,
      description:Appstring.onaboardingdescription2,
    ),
    OnboardingItem(
      imageUrl: Appimage.onboarding3,
  title: Appstring.onaboardingtitel3,
      description:Appstring.onaboardingdescription3,
    ),
  ];