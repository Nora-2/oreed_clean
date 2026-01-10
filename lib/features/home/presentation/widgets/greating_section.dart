import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class GreetingSection extends StatelessWidget {
  final String displayName;

  const GreetingSection({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (appTrans?.text('welcome_message') ?? 'هلا ومرحبا {name} 👋')
                .replaceAll('{name}', displayName),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appTrans?.text('home_subtitle') ??
                'عرض أغراضك واشتري اللي تحتاجه بدون تعب.',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
