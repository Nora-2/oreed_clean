// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:provider/provider.dart';



// class MainHomeTab extends StatefulWidget {
//   const MainHomeTab({super.key});

//   @override
//   State<MainHomeTab> createState() => _MainHomeTabState();
// }

// class _MainHomeTabState extends State<MainHomeTab> with RouteAware {
//   ModalRoute<dynamic>? _route;

//   @override
//   void initState() {
//     super.initState();

//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent, // set your desired color
//       statusBarIconBrightness: Brightness.light,
//     ));
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Execute pending notification navigation
//       NotificationService.executePendingNotificationNavigation(context);

//       // Fetch home data
//       context.read<MainHomeProvider>().fetchHomeData();
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Subscribe to route changes safely
//     final route = ModalRoute.of(context);
//     if (_route != route && route != null) {
//       if (_route != null) {
//         routeObserver.unsubscribe(this);
//       }
//       _route = route;
//       routeObserver.subscribe(this, route);
//     }
//   }

//   /// Called when a new route has been popped and this route shows up again.
//   @override
//   void didPopNext() {
//     // Refresh data when returning to this tab
//     final provider = context.read<MainHomeProvider>();
//     provider.fetchHomeData();
//     provider.refreshBanners();
//   }

//   @override
//   void dispose() {
//     if (_route != null) {
//       routeObserver.unsubscribe(this);
//     }
//     super.dispose();
//   }

//   Future<void> _onRefresh() async {
//     final provider = context.read<MainHomeProvider>();
//     // Execute all refreshes in parallel for better performance
//     await Future.wait([
//       provider.fetchHomeData(),
//       provider.refreshBanners(),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Resolve cached user name (Arabic preferred)
//     final prefs = AppSharedPreferences();
//     final String displayName = (prefs.userNameAr?.trim().isNotEmpty == true
//             ? prefs.userNameAr!
//             : (prefs.userName?.trim().isNotEmpty == true
//                 ? prefs.userName!
//                 : (AppTranslations.of(context)?.text('guest_name') ?? 'ضيف')))
//         .split(' ') // in case of full name, take first part
//         .first;

//     final appTrans = AppTranslations.of(context);

//     return Consumer<MainHomeProvider>(
//       builder: (context, provider, _) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF9F9F9),
//           // Clean background for the list
//           body: RefreshIndicator(
//             onRefresh: _onRefresh,
//             color: AppColors.primary,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Stack(
//                 children: [
//                   // 1. Background Image Layer (Top Only)
//                   Container(
//                     height: 320, // Height of the blue curved area
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/Frame 60204.png'),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(15),
//                         bottomRight: Radius.circular(15),
//                       ),
//                     ),
//                   ),

//                   // 2. Foreground Content Layer
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // --- Header Area (On top of Blue Image) ---
//                       SafeArea(
//                         bottom: false,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Top bar (Avatar & Notification)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 8.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const CircleAvatar(
//                                     radius: 20,
//                                     backgroundColor: Colors.transparent,
//                                     backgroundImage:
//                                         AssetImage('assets/images/logo.png'),
//                                   ),
//                                   IconButton(
//                                       tooltip: 'الإشعارات',
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const NotificationsScreen(),
//                                           ),
//                                         );
//                                       },
//                                       icon: SvgPicture.asset(
//                                         'assets/svg/notification.svg',
//                                         width: 25,
//                                         height: 25,
//                                       )),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(height: 2),

//                             // Greeting and subtitle
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     (appTrans?.text('welcome_message') ??
//                                             'هلا ومرحبا {name} 👋')
//                                         .replaceAll('{name}', displayName),
//                                     style: const TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.white70,
//                                       height: 1.25,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     appTrans?.text('home_subtitle') ??
//                                         'عرض أغراضك واشتري اللي تحتاجه بدون تعب.',
//                                     style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(height: 20),

//                             // Header search/actions
//                             const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16.0),
//                               child: HeaderSection(),
//                             ),
//                             const SizedBox(height: 20),

//                             // Inline banners (This will naturally overlap if height logic aligns, or sit nicely below)
//                             const BannerSection(sectionId: null),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 24),

//                       // --- Body Section (Categories & Ads) ---
//                       if (provider.status == HomeStatus.loading) ...[
//                         const _LoadingShimmer(),
//                       ] else if (provider.status == HomeStatus.error) ...[
//                         _ErrorState(
//                           errorMessage: provider.errorMessage,
//                           onRetry: () => provider.fetchHomeData(),
//                         ),
//                         const SizedBox(height: 24),
//                       ] else if (provider.status == HomeStatus.success) ...[
//                         // "Discover Sections" Title with Orange Bar
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 4,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF9F00),
//                                   // Orange accent
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   appTrans?.text('discover_sections') ??
//                                       'اكتشف الأقسام',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w800,
//                                     color: AppColors.textPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         CategorySection(categories: provider.sections),

//                         const SizedBox(height: 10),

//                         const RelatedAdsGroup(),

//                         const SizedBox(height: 80), // Bottom padding
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

