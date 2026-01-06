import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        image: DecorationImage(
          image: AssetImage(Appimage.homeBack),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
