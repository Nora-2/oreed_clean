import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

class HomeBackGroundWidget extends StatelessWidget {
  final Widget? child;
  final bool? isLoading;
  final bool? isAnim;
  final bool? isTryAgain;
  final void Function()? onTryAgain;
  final Color? bgColor;
  final String? title;
  final bool? notHasBack;
  final bool? notHasImage;
  final bool? hasScrool;
  final bool? hasBack;
  final Widget? bottomNavigationBar;
  final bool? centerTitle;
  final void Function()? backFunction;
  final EdgeInsetsGeometry? appBarMargin;
  final BorderRadiusGeometry? apBarBorderRadius;
  final Widget? apBarSideWidget;

  const HomeBackGroundWidget({
    super.key,
    this.child,
    this.isLoading,
    this.isAnim = false,
    this.isTryAgain,
    this.onTryAgain,
    this.bgColor,
    this.title,
    this.notHasBack,
    this.notHasImage,
    this.hasScrool = true,
    this.hasBack,
    this.bottomNavigationBar,
    this.centerTitle,
    this.backFunction,
    this.appBarMargin,
    this.apBarBorderRadius,
    this.apBarSideWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: bgColor ?? AppColors.whicolor),
            child: hasScrool == true
                ? SingleChildScrollView(child: buildChildView(context))
                : buildChildView(context),
          ),
          ///// loading container //////
          isLoading == false || isLoading == null
              ? const SizedBox()
              : Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: isAnim == false
                        ? ShimmerBox(
                            width: 80,
                            height: 80,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          )
                        : Lottie.asset(
                            'assets/anim/Main Scene.json',
                            width: 150,
                          ),
                  ),
                ),

          isTryAgain == true
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: CustomButton(
                      onTap: () => onTryAgain,
                      text: AppTranslations.of(context)!.text('tryAgain'),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  buildChildView(BuildContext context) {
    return Column(
      children: <Widget>[
        buildAppBar(context),
        child == null
            ? const SizedBox()
            : hasScrool == false
            ? Expanded(child: child!)
            : child!,
      ],
    );
  }

  buildAppBar(context) {
    return Container(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0, top: 25.0),
      height: 100.0, //70.0,
      margin: appBarMargin ?? const EdgeInsets.only(bottom: 15.0), //top: 25.0,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius:
            apBarBorderRadius ??
            const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          hasBack != null && hasBack == true
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: backFunction ?? () => Navigator.of(context).pop(),
                )
              : const SizedBox(
                  // width: 15.0,
                ),
          Expanded(
            // flex: 3,
            child: Text(
              title ?? '',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
          ),
          centerTitle != null && centerTitle == true
              ? const SizedBox()
              : Expanded(
                  child: Container(
                    child: apBarSideWidget == null
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [apBarSideWidget!],
                          ),
                  ),
                ),
        ],
      ),
    );
  }
}
