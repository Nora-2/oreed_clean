import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';

class AuthBack extends StatefulWidget {
  const AuthBack({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;

  final Widget child;

  @override
  State<AuthBack> createState() => _AuthBackState();
}

class _AuthBackState extends State<AuthBack> {
  late AppTranslations appTrans;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Slight background for the arrow
              ),
              child:  Icon(
                Icons.arrow_back,
                color: AppColors.primary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(children: [
          // Background Image
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Appimage.loginBack),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Space & Text
              SizedBox(height: size.height * 0.1),
              Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // White Bottom Sheet
              Expanded(
                child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ],
          )
        ]));
  }
}
