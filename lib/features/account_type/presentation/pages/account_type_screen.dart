import 'package:flutter/material.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/account_type/domain/entities/account_type_entity.dart';
import 'package:oreed_clean/features/account_type/presentation/widgets/account_type_card.dart';
import 'package:oreed_clean/features/account_type/presentation/widgets/build_header.dart';


class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  static const double _horizontalPadding = 16.0;
  static const double _headerTopPadding = 30.0;
  static const double _headerBottomPadding = 24.0;
  static const double _cardHeight = 210.0;
  static const double _bottomPadding = 20.0;
  static const double _titleFontSize = 22.0;
  static const double _contentRadius = 32.0;
  static const Color _topBorderColor = Color(0xFFFF8C00); // البرتقالي الرفيع

  List<AccountTypeEntity> _getTypes(BuildContext context) {
    return [
      AccountTypeEntity(
        type: AccountType.individual,
        title: AppTranslations.of(context)!.text('account_personal_title'),
        subtitle:
            AppTranslations.of(context)!.text('account_personal_subtitle'),
        imageAsset: Appimage.personal,
      ),
      AccountTypeEntity(
        type: AccountType.company,
        title: AppTranslations.of(context)!.text('account_company_title'),
        subtitle: AppTranslations.of(context)!.text('account_company_subtitle'),
        imageAsset: Appimage.company,
      ),
    ];
  }

  AccountType? _selected;

  void _onConfirm() {
    if (_selected == null) {
      _showErrorSnackBar(
          AppTranslations.of(context)!.text('select_account_type_error'));
      return;
    }
    print('Selected account type: $_selected');
    if (_selected == AccountType.individual) {
      Navigator.of(context).pushNamed(
       Routes.personalregister,
      );
    } else if (_selected == AccountType.company) {
      Navigator.of(context).pushNamed(
        Routes.companyregister,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

 

  void _onAccountTypeSelected(AccountType type) {
    setState(() => _selected = type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
              BuildHeader(horizontalPadding: _horizontalPadding, headerTopPadding: _headerTopPadding, headerBottomPadding: _headerBottomPadding, context: context, titleFontSize: _titleFontSize),


            Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius:BorderRadius.only(topRight: Radius.circular(_contentRadius),topLeft: Radius.circular(_contentRadius))), child: _buildContent())),
          ],
        ),
      ),
    );
  }


Widget _buildContent() {
  return Container(
    width: double.infinity, // Ensure it fills the width
    decoration: BoxDecoration(
      color: AppColors.whiteColor, // This is your white background
      border: Border(top: BorderSide(color: _topBorderColor, width: 3)),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(_contentRadius),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 32),
          _buildAccountTypeCards(),
          const Spacer(),
          _buildBottomButton(),
          const SizedBox(height: 32),
        ],
      ),
    ),
  );
}

  Widget _buildAccountTypeCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: SizedBox(
        height: _cardHeight,
        child: Row(
          children: List.generate(_getTypes(context).length, (index) {
            final model = _getTypes(context)[index];
            final isSelected = _selected == model.type;
            return AccountTypeCard(
              model: model,
              isSelected: isSelected,
              onTap: () => _onAccountTypeSelected(model.type),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        0,
        _horizontalPadding,
        _bottomPadding,
      ),
      child: CustomButton(
        text: AppTranslations.of(context)!.text('confirm'),
        onTap: _onConfirm,
      ),
    );
  }
}
