// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/circelback.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
// import 'package:oreed_clean/features/home/presentation/widgets/search_field.dart';
// import 'package:provider/provider.dart';
// class AdvancedSearchScreen extends StatefulWidget {
//   final String initialSearchQuery;

//   const AdvancedSearchScreen({
//     super.key,
//     required this.initialSearchQuery,
//   });

//   @override
//   State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
// }

// class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent, // set your desired color
//       statusBarIconBrightness:
//           Brightness.dark, // light icons (for dark background)
//     ));
//     _searchController.text = widget.initialSearchQuery;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AdvancedSearchProvider>().search(widget.initialSearchQuery);
//     });

//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       final provider = context.read<AdvancedSearchProvider>();
//       if (provider.hasNextPage && !provider.isLoading) {
//         provider.loadNextPage();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _performSearch() {
//     final query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       FocusScope.of(context).unfocus();
//       context.read<AdvancedSearchProvider>().search(query);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppTranslations.of(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Back Button
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//               child:CircleBack(context: context, background_color: Color(0xffe8e8e9))
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 t?.text('Listofworkers') ?? (t?.text('search_results') ?? 'Search Results'),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: HomeSearchField(),
//             ),
//             const SizedBox(height: 16),

//             Expanded(
//               child: Consumer<AdvancedSearchProvider>(
//                 builder: (context, provider, _) {
//                   if (provider.isLoading && provider.searchResults.isEmpty) {
//                     return _buildShimmerLoading();
//                   }
//                   if (provider.hasError) {
//                     return _buildErrorView(provider);
//                   }
//                   if (!provider.hasResults) {
//                     return _buildNoResults();
//                   }

//                   return _buildResultsList(provider);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }



//   // UPDATED: This now builds a list of ALL sections
//   Widget _buildResultsList(AdvancedSearchProvider provider) {
//     // Calculate total results across all sections
//     int totalCount = 0;
//     for (var section in provider.searchResults) {
//       totalCount += (section.companyCount + section.categoryCount);
//     }

//     return RefreshIndicator(
//       onRefresh: () => provider.refresh(),
//       child: ListView.builder(
//         controller: _scrollController,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: provider.searchResults.length + 1, // +1 for the header count
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             return Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//               child: _buildResultCount(totalCount),
//             );
//           }

//           final section = provider.searchResults[index - 1];

//           // Only show section if it has data
//           if (section.companies.isEmpty && section.categories.isEmpty) {
//             return const SizedBox.shrink();
//           }

//           return _buildSectionCard(section);
//         },
//       ),
//     );
//   }

//   Widget _buildSectionCard(SearchSection section) {
//       final tr = AppTranslations.of(context);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xffE8E8E9).withOpacity(.15),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Section Header
//           Row(
//             children: [
//               Container(
//                 width: 3,
//                 height: 20,
//                 decoration: BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.circular(2)),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 section.name,
//                 style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff333333)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//             Text('${tr?.text('search_results_companies') ?? 'نتائج البحث في الشركات'} (${section.companyCount})',
//                 style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 30),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: section.companies.length,
//               // Uses actual list length
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//               itemBuilder: (context, index) => _buildGridItem(
//                 id: section.companies[index].id,
//                 name: section.companies[index].name,
//                 image: 'assets/images/companytest.png',
//                 // Ensure your model has .image
//                 sectionId: section.sectionId,
//                 isCompany: true,
//               ),
//             ),
//             const SizedBox(height: 30),
   
//           if (section.categories.isNotEmpty) ...[
//             Text('${tr?.text('search_results_categories') ?? 'نتائج البحث في الاقسام'} (${section.categoryCount})',
//                 style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 30),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: section.categories.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 6,
//               ),
//               itemBuilder: (context, index) => _buildGridItem(
//                 id: section.categories[index].id,
//                 name: section.categories[index].name,
//                 image: 'assets/images/p1.png',
//                 sectionId: section.sectionId,
//                 isCompany: false,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildGridItem({
//     required int id,
//     required String name,
//     required String? image,
//     required int sectionId,
//     required bool isCompany,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         if (isCompany) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => CompanyDetailsScreen(
//                         companyId: id,
//                         sectionId: sectionId,
//                         searchText: context
//                             .read<AdvancedSearchProvider>()
//                             .currentSearchQuery,
//                       )));
//         } else {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => SubCategoryIntroScreen(
//                         categoryId: id,
//                         sectionId: sectionId,
//                         title: name,
//                         searchText: context
//                             .read<AdvancedSearchProvider>()
//                             .currentSearchQuery,
//                       )));
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade200, width: 1),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image Section
//             Expanded(
//               flex: 3,
//               child: Center(
//                 child: ClipOval(
//                   child: SizedBox(
//                     width: 80,
//                     height: 80,
//                     child: image != null
//                         ? Image.asset(
//                             image!,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.network(
//                             image!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => const Icon(
//                               Icons.business,
//                               color: Colors.grey,
//                               size: 32,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ),

//             // Text Section
//             Expanded(
//               flex: 1,
//               child: Center(
//                 child: Text(
//                   name,
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                       fontFamily: 'Almarai'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultCount(int count) {
//     final t = AppTranslations.of(context);
//     return Text(
//       '$count ${t?.text('Listofworkers')}',
//       style: const TextStyle(
//           color: Color(0xff676768), fontWeight: FontWeight.w500, fontSize: 14),
//     );
//   }

//   // Rest of your helper methods (Shimmer, Error, NoResults) remain the same...
//   Widget _buildShimmerLoading() =>
//       const Center(child: CircularProgressIndicator());

//   Widget _buildErrorView(AdvancedSearchProvider provider) =>
//       Center(child: Text(provider.errorMessage ?? 'Error'));

//   Widget _buildNoResults() {
//       final tr = AppTranslations.of(context);

//     return Center(
//       child: emptyAdsView(
//         context: context,
//         title: tr?.text('no_results_found') ?? 'لا توجد نتائج',
//         subtitle: tr?.text('no_results_subtitle') ??
//             'لم نعثر على نتائج مطابقة لبحثك.',
//         image: 'assets/svg/emptysearch.svg',
//         visible: false,
//         onAddPressed: () {},
//         button: '',
//       ),
//     );
//   }
// }
