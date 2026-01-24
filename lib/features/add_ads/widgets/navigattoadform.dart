import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/routing/routes.dart';

class AppNavigator {
  static void navigateToAdForm({
    required BuildContext context,
    required int sectionId,
    required int companyId,
    required int companyTypeId,
    int categoryId = 0,
    int supCategoryId = 0,
  }) {
    final sectionType = SectionTypeExtension.fromId(sectionId);

    switch (sectionType) {
      case SectionType.car:
        Navigator.pushNamed(
          context,
          Routes.carForm,arguments: {'sectionId': sectionId,
              'supCategoryId': supCategoryId,
              'categoryId': categoryId,
              'companyId': companyId,
              'companyTypeId': companyTypeId,}
         
        );
        break;
      case SectionType.property:
        Navigator.pushNamed (
          context,
          Routes.realstateform,
          arguments: {'sectionId': sectionId,
              'supCategoryId': supCategoryId,
              'categoryId': categoryId,
              'companyId': companyId,
              'companyTypeId': companyTypeId,}
         
        
        );
        break;
      case SectionType.technical:
        Navigator.pushNamed(
          context,
          Routes.technicanform,
          arguments: { 'sectionID': sectionId,
              'categoryId': categoryId,
              'companyId': companyId,
              'companyTypeId': companyTypeId,}
       
        );
        break;
      case SectionType.normal:
        Navigator.pushNamed(
          context,
          Routes.anythingform,
          arguments: {'sectionId': sectionId,
              'categoryId': categoryId,
              'supCategoryId': supCategoryId,
              'companyId': companyId,
              'companyTypeId': companyTypeId,}
         
        
        );
        break;
    }
  }
}
