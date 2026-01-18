
// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:oreed_clean/core/app_shared_prefs.dart';
// import 'package:oreed_clean/core/enmus/enum.dart' hide PaymentResult, ImageSourceChoice;
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
// import 'package:oreed_clean/core/utils/appimage/app_images.dart';
// import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
// import 'package:oreed_clean/core/utils/option_item_register.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
// import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
// import 'package:oreed_clean/features/forms/domain/entities/city_entity.dart';
// import 'package:oreed_clean/features/forms/presentation/widgets/hero_image_tile.dart';
// import 'package:oreed_clean/features/forms/presentation/widgets/image_source_sheet.dart';
// import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
// import 'package:oreed_clean/networking/api_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../domain/entities/state_entity.dart';

// class TechnicianFormUI extends StatefulWidget {
//   const TechnicianFormUI({
//     super.key,
//     required this.categoryId,
//     required this.sectionID,
//     this.companyId,
//     this.companyTypeId,
//     this.adId,
//   });

//   final int categoryId;
//   final int sectionID;
//   final int? companyId;
//   final int? companyTypeId;
//   final int? adId;

//   @override
//   State<TechnicianFormUI> createState() => _TechnicianFormUIState();
// }

// class _TechnicianFormUIState extends State<TechnicianFormUI> {
//   static final _blue = AppColors.primary;
//   static final _orange = AppColors.secondary;

//   bool get _isEditing => widget.adId != null;

//   final _nameCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _phone = TextEditingController();
//   final _whatsapp = TextEditingController();
//   final _picker = ImagePicker();

//   // main image (either local file or remote URL)
//   File? _mainImageFile;
//   String? _mainImageUrl;

//   // gallery remote items (media with IDs) and local picked files
//   final List<MediaItem> _galleryRemote = [];
//   final List<File> _galleryLocal = [];

//   // set of media IDs currently being deleted
//   final Set<int> _deletingRemote = {};

//   bool _isLoading = false;

//   StateEntity? _selectedState;
//   CityEntity? _selectedCity;

//   @override
//   void initState() {
//     super.initState();
//     final provider = context.read<TechnicianFormProvider>();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await provider.fetchStates();
//       if (_isEditing) {
//         await provider.fetchTechnicianDetails(widget.adId!);
//         final d = provider.loadedDetails;
//         if (d != null) {
//           _nameCtrl.text = d.name;
//           _descCtrl.text = d.description;
//           _phone.text = d.phone;
//           _whatsapp.text = d.whatsapp;
//           // populate main image and gallery separately
//           _galleryRemote.addAll(d.media);
//           _mainImageUrl = d.mainImageUrl;

//           // set selected state/city
//           _selectedState = StateEntity(id: d.stateId, name: d.stateName!);
//           await provider.fetchCities(d.stateId);
//           _selectedCity = CityEntity(id: d.cityId, name: d.cityName!);
//           setState(() {}); // ensure rebuild after asyncs
//         }
//       }
//     });
//   }

//   Future<void> _pickMainFromGallery() async {
//     final image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//       maxWidth: 1920,
//       maxHeight: 1920,
//     );
//     if (image != null) {
//       setState(() {
//         _mainImageFile = File(image.path);
//         _mainImageUrl = null;
//       });
//     }
//   }

//   Future<void> _pickMainFromCamera() async {
//     final image = await _picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 85,
//       maxWidth: 1920,
//       maxHeight: 1920,
//     );
//     if (image != null) {
//       setState(() {
//         _mainImageFile = File(image.path);
//         _mainImageUrl = null;
//       });
//     }
//   }

//   Future<void> _pickGalleryFromGallery() async {
//     final images = await _picker.pickMultiImage(
//       imageQuality: 85,
//       maxWidth: 1920,
//       maxHeight: 1920,
//     );
//     if (images.isNotEmpty) {
//       setState(() => _galleryLocal.addAll(images.map((e) => File(e.path))));
//     }
//   }

//   Future<void> _pickGalleryFromCamera() async {
//     final image = await _picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 85,
//       maxWidth: 1920,
//       maxHeight: 1920,
//     );
//     if (image != null) {
//       setState(() => _galleryLocal.add(File(image.path)));
//     }
//   }

//   Future<bool> _deleteRemoteImageApi(
//       {required String adId, required String imageId}) async {
//     try {
//       // get token from shared prefs (sync getter)
//       final token = AppSharedPreferences().getUserToken ??
//           AppSharedPreferences().userToken;
//       if (token == null || token.trim().isEmpty) {
//         if (mounted) {
//           final appTrans = AppTranslations.of(context);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(appTrans?.text('auth.login_required_action') ??
//                   'Please login to perform this action')));
//         }
//         return false;
//       }

//       final headers = {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final uri =
//           Uri.parse('${ApiProvider.baseUrl}/api/v1/remove_technician_image');
//       final request = http.MultipartRequest('POST', uri);
//       request.fields.addAll({'ad_id': adId, 'image_id': imageId});
//       request.headers.addAll(headers);

//       final streamed = await request.send();
//       if (streamed.statusCode == 200) {
//         final body = await streamed.stream.bytesToString();
//         // optional: parse body
//         print('delete success: $body');
//         return true;
//       } else {
//         print('delete failed: ${streamed.reasonPhrase}');
//         return false;
//       }
//     } catch (e) {
//       print('delete exception: $e');
//       return false;
//     }
//   }

//   Future<void> _confirmAndDeleteRemote(MediaItem mediaItem,
//       {bool isMain = false}) async {
//     if (isMain) {
//       if (mounted) {
//         final appTrans = AppTranslations.of(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(appTrans?.text('error.cannot_delete_main_image') ??
//                 'Main image cannot be deleted. You can change it instead.'),
//           ),
//         );
//       }
//       return;
//     }

//     if (widget.adId == null) return;

//     final appTrans = AppTranslations.of(context);
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(appTrans?.text('common.confirm') ?? 'Confirm'),
//         content: Text(appTrans?.text('photos.confirm_delete') ??
//             'Are you sure you want to delete this photo?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(appTrans?.text('common.no') ?? 'No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(appTrans?.text('common.yes') ?? 'Yes'),
//           ),
//         ],
//       ),
//     );

//     if (shouldDelete != true) return;

//     setState(() => _deletingRemote.add(mediaItem.id));

//     final success = await _deleteRemoteImageApi(
//       adId: widget.adId!.toString(),
//       imageId: mediaItem.id.toString(),
//     );

//     if (mounted) setState(() => _deletingRemote.remove(mediaItem.id));

//     if (success) {
//       await _refreshDetailsAfterDelete();
//       if (mounted) {
//         final appTrans = AppTranslations.of(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   appTrans?.text('photos.delete_success') ?? 'Photo deleted')),
//         );
//       }
//     } else {
//       if (mounted) {
//         final appTrans = AppTranslations.of(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(appTrans?.text('photos.delete_failed') ??
//                   'Failed to delete photo')),
//         );
//       }
//     }
//   }

//   Future<void> _refreshDetailsAfterDelete() async {
//     if (widget.adId == null) return;

//     try {
//       final provider = context.read<TechnicianFormProvider>();
//       await provider.fetchTechnicianDetails(widget.adId!);

//       final details = provider.loadedDetails;
//       if (details != null && mounted) {
//         setState(() {
//           _galleryRemote
//             ..clear()
//             ..addAll(details.media);
//           if (_mainImageFile == null) {
//             _mainImageUrl = details.mainImageUrl;
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         final appTrans = AppTranslations.of(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   '${appTrans?.text('error.data_refresh_failed') ?? 'Error refreshing data'}: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Color _tagColor(int tag) {
//     switch (tag % 6) {
//       case 0:
//         return const Color(0xFF2563EB);
//       case 1:
//         return const Color(0xFF16A34A);
//       case 2:
//         return const Color(0xFFF59E0B);
//       case 3:
//         return const Color(0xFFEF4444);
//       case 4:
//         return const Color(0xFF8B5CF6);
//       default:
//         return const Color(0xFF0EA5E9);
//     }
//   }

//   List<String> _validateFields(AppTranslations? appTrans) {
//     final errors = <String>[];

//     final name = _nameCtrl.text.trim();
//     if (name.isEmpty || name.length < 3) {
//       errors.add('name');
//     }

//     if (_selectedState == null) errors.add('state');
//     if (_selectedCity == null) errors.add('city');

//     final description = _descCtrl.text.trim();
//     if (description.isEmpty ) {
//       errors.add('description');
//     }

//     // Only require main image on CREATE
//     if (!_isEditing && _mainImageFile == null && _mainImageUrl == null) {
//       errors.add('images');
//     }

//     return errors;
//   }

//   List<OptionItemregister> _toOptionItems<T>(
//     List<T> items,
//     String Function(T) labelOf,
//     String icon, {
//     bool forCity = false,
//   }) {
//     return List.generate(
//       items.length,
//       (i) => OptionItemregister(
//         label: labelOf(items[i]),
//         icon: icon,
//       ),
//     );
//   }

//   T? _findByLabel<T>(List<T> items, String Function(T) labelOf, String label) {
//     for (final item in items) {
//       if (labelOf(item) == label) return item;
//     }
//     return null;
//   }

//   // remove a locally picked gallery image
//   void _removeLocalGalleryAt(int i) =>
//       setState(() => _galleryLocal.removeAt(i));

//   List<ReviewSection> _buildTechnicianReviewSections(
//       AppTranslations? appTrans) {
//     String dash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v;

//     // Prepare main image for review (only local File objects)
//     final List<File> mainImageForReview = [];
//     if (_mainImageFile != null) {
//       mainImageForReview.add(_mainImageFile!);
//     }

//     // Prepare gallery images for review (only local File objects)
//     final List<File> galleryImagesForReview = [..._galleryLocal];

//     // Build review sections
//     final sections = <ReviewSection>[
//       ReviewSection(
//         keyName: 'basics',
//         title: appTrans?.text('review.basics_location') ??
//             'المعلومات الأساسية والموقع',
//         items: [
//           ReviewItem(
//               label: '${appTrans?.text('field.name') ?? 'Name'}:',
//               value: dash(_nameCtrl.text)),
//           ReviewItem(
//               label: '${appTrans?.text('field.state') ?? 'Governorate'}:',
//               value: _selectedState?.name ?? '-'),
//           ReviewItem(
//               label: '${appTrans?.text('field.city') ?? 'City'}:',
//               value: _selectedCity?.name ?? '-'),
//         ],
//       ),
//       ReviewSection(
//         keyName: 'details',
//         title: appTrans?.text('field.description') ?? 'الوصف',
//         items: [
//           ReviewItem(
//               label: '${appTrans?.text('field.description') ?? 'Description'}:',
//               value: dash(_descCtrl.text))
//         ],
//       ),
//     ];

//     // Add main image section if available
//     if (mainImageForReview.isNotEmpty) {
//       sections.add(ReviewSection(
//         keyName: 'main_photo',
//         title: appTrans?.text('photos.main_image') ?? 'الصورة الرئيسية',
//         items: const [],
//         images: mainImageForReview,
//       ));
//     } else if (_mainImageUrl != null) {
//       // If only remote URL exists, show it as a text item
//       sections.add(ReviewSection(
//         keyName: 'main_photo_info',
//         title: '',
//         items: [
//           ReviewItem(
//             label: appTrans?.text('photos.current_image') ?? 'الصورة الحالية',
//             value: appTrans?.text('photos.image_exists') ?? 'موجودة على الخادم',
//             icon: Icons.check_circle,
//           ),
//         ],
//       ));
//     }

//     // Add gallery section if available
//     if (galleryImagesForReview.isNotEmpty) {
//       sections.add(ReviewSection(
//         keyName: 'gallery_photos',
//         title: appTrans?.text('photos.gallery') ?? 'صور المعرض',
//         items: const [],
//         images: galleryImagesForReview,
//       ));
//     } else if (_galleryRemote.isNotEmpty) {
//       // If only remote URLs exist, show count as text
//       sections.add(ReviewSection(
//         keyName: 'gallery_info',
//         title: '',
//         items: [
//           ReviewItem(
//             label: '',
//             value:
//                 '${_galleryRemote.length} ${appTrans?.text('photos.images_on_server') ?? 'صورة على الخادم'}',
//             icon: Icons.photo_library,
//           ),
//         ],
//       ));
//     }

//     return sections;
//   }

//   void _showFillAllFieldsSnack(AppTranslations? appTrans) {
//     final msg = appTrans?.text('validation.fill_all_fields') ??
//         'من فضلك أدخل جميع الحقول المطلوبة';

//     final bar = SnackBar(
//       content: Row(
//         children: [
//           const Icon(Icons.info_outline_rounded, color: Colors.white),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               msg,
//               style: const TextStyle(fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: AppColors.accentLight,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 3),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(bar);
//   }

//   Future<void> _submitAd(AppTranslations? appTrans) async {
//     final provider = context.read<TechnicianFormProvider>();

//     if (_validateFields(appTrans).isNotEmpty) {
//       _showFillAllFieldsSnack(appTrans);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final userId = AppSharedPreferences().getUserIdD();
//       if (userId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(appTrans?.text('error.user_not_found') ??
//                 'لم يتم العثور على بيانات المستخدم، يرجى تسجيل الدخول مجددًا'),
//           ),
//         );
//         setState(() => _isLoading = false);
//         return;
//       }

//       if (_isEditing) {
//         // EDIT
//         await provider.updateAd(
//           id: widget.adId!,
//           name: _nameCtrl.text,
//           description: _descCtrl.text,
//           phone: _phone.text,
//           whatsapp: _whatsapp.text,
//           userId: userId,
//           sectionId: widget.sectionID,
//           categoryId: widget.categoryId,
//           stateId: _selectedState!.id,
//           cityId: _selectedCity!.id,
//           // if user picked a new main image use it, otherwise keep existing remote main
//           mainImage: _mainImageFile ??
//               (_galleryLocal.isNotEmpty ? _galleryLocal.first : null),
//           galleryImages: _galleryLocal,
//           companyId: widget.companyId,
//           companyTypeId: widget.companyTypeId,
//         );

//         if (provider.status == TechnicianFormStatus.success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(appTrans?.text('success.technician_updated') ??
//                   'Ad updated successfully ✅'),
//             ),
//           );
//           if (context.mounted) {
//             Navigator.pop(context); // back to previous screen
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(provider.errorMessage ??
//                   (appTrans?.text('error.submit_failed') ??
//                       'An error occurred while submitting')),
//             ),
//           );
//         }
//       } else {
//         await provider.submitAd(
//           name: _nameCtrl.text,
//           description: _descCtrl.text,
//           phone: _phone.text,
//           whatsapp: _whatsapp.text,
//           userId: userId,
//           sectionId: widget.sectionID,
//           categoryId: widget.categoryId,
//           stateId: _selectedState!.id,
//           cityId: _selectedCity!.id,
//           mainImage: _mainImageFile!,
//           galleryImages: _galleryLocal,
//           companyId: widget.companyId,
//           companyTypeId: widget.companyTypeId,
//         );

//         if (provider.status == TechnicianFormStatus.success) {
//           // if (mounted) {
//           //   await _showAdSuccessSheet();
//           // }

//           if (widget.companyId != null) {
//             Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
//           } else {
//             final choice = await PinChoiceScreen.show(context);

//             if (choice == null || choice.isFree) {
//               Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
//             } else {
//               final url = Uri.parse(
//                   '${ApiProvider.baseUrl}/payment/request?user_id=$userId&packageId=${choice.id}&ads_id=${provider.response!.id ?? 0}&model=technician');

//               final result = await Navigator.push<PaymentResult>(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PaymentWebView(
//                     url: url.toString(),
//                     title: AppTranslations.of(context)!.text('payment_title') ?? 'الدفع',
//                     successMatcher: (u) =>
//                         u.contains('payment/success') ||
//                         u.contains('status=success'),
//                     cancelMatcher: (u) =>
//                         u.contains('payment/cancel') ||
//                         u.contains('status=cancel'),
//                   ),
//                 ),
//               );

//               if (!context.mounted) return;

//               if (result == PaymentResult.success) {
//                 context.read<HomeProvider>().changeTabIndex(2);
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, '/home', (_) => false);
//               } else if (result == PaymentResult.cancelled) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(appTrans?.text('payment.cancelled') ??
//                         'Payment cancelled'),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(appTrans?.text('payment.failed') ??
//                         'Payment failed, try again'),
//                   ),
//                 );
//               }
//             }
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(provider.errorMessage ??
//                     (appTrans?.text('error.submit_failed') ??
//                         'An error occurred while submitting'))),
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               '${appTrans?.text('error.publish_exception') ?? 'An error occurred while publishing'}: ${e.toString()}'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Helper widget: main image tile (remote or local)
//   Widget _buildMainImageTile(AppTranslations? appTrans) {
//     return SizedBox(
//       height: 150,
//       child: _mainImageFile != null
//           ? HeroImageTile(
//               file: _mainImageFile,
//               onAdd: () async {
//                 final choice = await showImageSourceSheet(context);
//                 if (choice == ImageSourceChoice.camera) {
//                   await _pickMainFromCamera();
//                 } else if (choice == ImageSourceChoice.gallery) {
//                   await _pickMainFromGallery();
//                 }
//               },
//               onChange: () async {
//                 final choice = await showImageSourceSheet(context);
//                 if (choice == ImageSourceChoice.camera) {
//                   await _pickMainFromCamera();
//                 } else if (choice == ImageSourceChoice.gallery) {
//                   await _pickMainFromGallery();
//                 }
//               },
//               onRemove: () => setState(() => _mainImageFile = null),
//               borderColor: const Color(0xFFE5E7EB),
//               accentColor: _blue,
//               thumbnail: true,
//               thumbSize: 110,
//               showLabel: true,
//               label: appTrans?.text('photos.main_image') ?? 'Main image',
//               addTileRedStyle: false,
//               deleteBgColor: const Color(0xFFE11D48),
//             )
//           : (_mainImageUrl != null
//               ? Stack(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFFE5E7EB)),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           _mainImageUrl!,
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 8,
//                       top: 8,
//                       child: GestureDetector(
//                         onTap: () async {
//                           final choice = await showImageSourceSheet(context);
//                           if (choice == ImageSourceChoice.camera) {
//                             await _pickMainFromCamera();
//                           } else if (choice == ImageSourceChoice.gallery) {
//                             await _pickMainFromGallery();
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF0EA5E9),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.edit,
//                               size: 18, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : HeroImageTile(
//                   file: null,
//                   onAdd: () async {
//                     final choice = await showImageSourceSheet(context);
//                     if (choice == ImageSourceChoice.camera) {
//                       await _pickMainFromCamera();
//                     } else if (choice == ImageSourceChoice.gallery) {
//                       await _pickMainFromGallery();
//                     }
//                   },
//                   onChange: () {},
//                   onRemove: () {},
//                   borderColor: const Color(0xFFE5E7EB),
//                   accentColor: _orange,
//                   thumbnail: true,
//                   thumbSize: 110,
//                   showLabel: true,
//                   label: appTrans?.text('add_image') ?? 'Addimage',
//                   addTileRedStyle: true,
//                   deleteBgColor: const Color(0xFFE11D48),
//                 )),
//     );
//   }

//   // Helper widget: gallery add tile
//   Widget _buildGalleryAddTile(AppTranslations? appTrans) {
//     return SizedBox(
//       height: 150,
//       child: HeroImageTile(
//         file: null,
//         onAdd: () async {
//           final choice = await showImageSourceSheet(context);
//           if (choice == ImageSourceChoice.camera) {
//             await _pickGalleryFromCamera();
//           } else if (choice == ImageSourceChoice.gallery) {
//             await _pickGalleryFromGallery();
//           }
//         },
//         onChange: () async {
//           final choice = await showImageSourceSheet(context);
//           if (choice == ImageSourceChoice.camera) {
//             await _pickGalleryFromCamera();
//           } else if (choice == ImageSourceChoice.gallery) {
//             await _pickGalleryFromGallery();
//           }
//         },
//         onRemove: () {},
//         borderColor: const Color(0xFFE5E7EB),
//         accentColor: _blue,
//         thumbnail: true,
//         thumbSize: 110,
//         showLabel: true,
//         label: appTrans?.text('photos.add_gallery') ?? 'Add gallery images',
//         addTileRedStyle: true,
//         deleteBgColor: const Color(0xFFE11D48),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _descCtrl.dispose();
//     _phone.dispose();
//     _whatsapp.dispose();
//     _galleryRemote.clear();
//     _galleryLocal.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<TechnicianFormProvider>();
//     final appTrans = AppTranslations.of(context);

//     // print(widget.companyId);
//     // print(widget.companyTypeId);
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage(Appimage.addAdDetails))),
//         child: SafeArea(
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: const Color(0xffe8e8e9),
//                           borderRadius: BorderRadius.circular(25)),
//                       padding: const EdgeInsets.all(6),
//                       child:  Icon(
//                         Icons.arrow_back,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 40),
//                   Text(
//                     appTrans?.text('page.enter_technician_details') ??
//                         'Enter your ad details',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   AppTextField(
//                     controller: _nameCtrl,
//                     hint: appTrans?.text('hint.name') ?? 'Enter full name',
//                     label: Text.rich(
//                       TextSpan(
//                         children: [
//                           // Part 1: The localized text (ensure this string does NOT contain the asterisk)
//                           TextSpan(
//                             text: appTrans?.text('field.name') ?? 'Name',
//                           ),
//                           // Part 2: The Red Asterisk
//                           const TextSpan(
//                             text: ' *',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     validator: (val) => val!.isEmpty
//                         ? (appTrans?.text('validation.enter_name') ??
//                             'Please enter name')
//                         : null,
//                   ),

//                   const SizedBox(
//                     height: 30,
//                   ),

//                   SelectSheetFieldads(
//                     label: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             text:
//                                 appTrans?.text('field.state') ?? 'Governorate',
//                           ),
//                           TextSpan(
//                             text: ' *',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     hint: _selectedState?.name ??
//                         (appTrans?.text('select.choose_state') ??
//                             'Select Governorate'),
//                     // Move the logic HERE:
//                     onTap: () async {
//                       final states = provider.states;
//                       if (states.isEmpty) {
//                         await provider.fetchStates();
//                       }
//                       if (provider.status == TechnicianFormStatus.error) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(provider.errorMessage ??
//                                 (appTrans?.text('error.failed_load_states') ??
//                                     'Failed to load governorates'))));
//                         return;
//                       }
//                       final options = _toOptionItems(
//                         states,
//                         (s) => s.name,
//                         AppIcons.locationCountry,
//                         forCity: false,
//                       );
//                       final chosenLabel = await showAppOptionSheetregister(
//                         context: context,
//                         title: appTrans?.text('select.choose_state') ??
//                             'Select Governorate',
//                         options: options,
//                         tagColor: _tagColor,
//                         current: _selectedState?.name,
//                         hint: appTrans?.text('hint.search_state') ??
//                             'Search for governorate',
//                         subtitle: appTrans?.text('select.state_subtitle') ??
//                             'Choose your governorate to view ads and services.',
//                       );
//                       if (chosenLabel != null) {
//                         final chosen = _findByLabel<StateEntity>(
//                           states,
//                           (s) => s.name,
//                           chosenLabel,
//                         );
//                         if (chosen != null) {
//                           setState(() {
//                             _selectedState = chosen;
//                             _selectedCity = null;
//                           });
//                           await provider.fetchCities(chosen.id);
//                         }
//                       }
//                     },
//                   ),

//                   // ===== المدينة =====
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   SelectSheetFieldads(
//                     hint: _selectedCity?.name ??
//                         (appTrans?.text('select.choose_city') ?? 'Select City'),
//                     label: Text.rich(
//                       TextSpan(
//                         children: [
//                           // Part 1: The localized text (ensure this string does NOT contain the asterisk)
//                           TextSpan(
//                             text: _selectedState == null
//                                 ? (appTrans?.text('field.city') ??
//                                     'Please select governorate first')
//                                 : (provider.cities.isEmpty
//                                     ? (appTrans?.text('field.city') ??
//                                         'Select City')
//                                     : (appTrans?.text('field.city') ??
//                                         'Select City')),
//                           ),
//                           // Part 2: The Red Asterisk
//                           const TextSpan(
//                             text: ' *',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     onTap: () async {
//                       if (_selectedState == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(
//                                 appTrans?.text('error.select_state_first') ??
//                                     'Please select governorate first')));
//                         return;
//                       }

//                       final cities = provider.cities;
//                       if (cities.isEmpty) {
//                         await provider.fetchCities(_selectedState!.id);
//                       }

//                       if (provider.status == TechnicianFormStatus.error) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(provider.errorMessage ??
//                                 (appTrans?.text('error.failed_load_cities') ??
//                                     'Failed to load cities'))));
//                         return;
//                       }

//                       final options = _toOptionItems(
//                         cities,
//                         (c) => c.name,
//                         'assets/svg/location.svg',
//                         forCity: true,
//                       );
//                       final chosenLabel = await showAppOptionSheetregister(
//                         context: context,
//                         title: appTrans?.text('select.choose_city') ??
//                             'Select City',
//                         options: options,
//                         tagColor: _tagColor,
//                         current: _selectedCity?.name,
//                         hint: appTrans?.text('hint.search_city') ??
//                             'Search for city',
//                         subtitle: appTrans?.text('select.state_subtitle') ??
//                             'Choose your governorate to view ads and services.',
//                       );

//                       if (chosenLabel != null) {
//                         final chosen = _findByLabel<CityEntity>(
//                           cities,
//                           (c) => c.name,
//                           chosenLabel,
//                         );
//                         if (chosen != null) {
//                           setState(() => _selectedCity = chosen);
//                         }
//                       }
//                     },
//                   ),

//                   const SizedBox(
//                     height: 30,
//                   ),
//                   AppTextField(
//                     controller: _descCtrl,
//                     hint: appTrans?.text('hint.description') ??
//                         'Write service/product details...',
//                     max: 10,
//                     min: 5,
//                     keyboardType: TextInputType.multiline,
//                     label: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                               text: appTrans?.text('field.description') ??
//                                   'Description'),
//                           const TextSpan(
//                             text: ' *',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     validator: (String? p1) {},
//                   ),

//                   const SizedBox(height: 30),

//                   _buildMainImageTile(appTrans),
//                   const SizedBox(height: 20),
//                   _buildGalleryAddTile(appTrans),

//                   const SizedBox(height: 10),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _galleryRemote.length + _galleryLocal.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 16,
//                       mainAxisExtent: 100,
//                     ),
//                     itemBuilder: (context, i) {
//                       if (i < _galleryRemote.length) {
//                         final mediaItem = _galleryRemote[i];
//                         return Stack(
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(mediaItem.url,
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.cover)),
//                             Positioned(
//                               right: 6,
//                               top: 6,
//                               child: _deletingRemote.contains(mediaItem.id)
//                                   ? Container(
//                                       width: 28,
//                                       height: 28,
//                                       decoration: const BoxDecoration(
//                                           color: Colors.black45,
//                                           shape: BoxShape.circle),
//                                       padding: const EdgeInsets.all(6),
//                                       child: const SizedBox(
//                                           width: 16,
//                                           height: 16,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2.2,
//                                             color: Colors.white,
//                                           )),
//                                     )
//                                   : GestureDetector(
//                                       onTap: () => _confirmAndDeleteRemote(
//                                           mediaItem,
//                                           isMain: false),
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                             color: Color(0xFFE11D48),
//                                             shape: BoxShape.circle),
//                                         padding: const EdgeInsets.all(6),
//                                         child: const Icon(Icons.close,
//                                             size: 16, color: Colors.white),
//                                       ),
//                                     ),
//                             )
//                           ],
//                         );
//                       } else {
//                         final localIndex = i - _galleryRemote.length;
//                         final f = _galleryLocal[localIndex];
//                         return Stack(
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.file(f,
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.cover)),
//                             Positioned(
//                               right: 6,
//                               top: 6,
//                               child: GestureDetector(
//                                 onTap: () => _removeLocalGalleryAt(localIndex),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                       color: Color(0xFFE11D48),
//                                       shape: BoxShape.circle),
//                                   padding: const EdgeInsets.all(6),
//                                   child: const Icon(Icons.close,
//                                       size: 16, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//                     },
//                   ),

//                   const SizedBox(height: 10),

//                   CustomButton(
//                     text: _isLoading
//                         ? (appTrans?.text('action.sending') ?? 'Sending...')
//                         : _isEditing
//                             ? (appTrans?.text('action.save_changes') ??
//                                 'Save Changes')
//                             : (appTrans?.text('common.next') ?? 'Next'),
//                     // ...
//                     onTap: _isLoading
//                         ? () {}
//                         : () {
//                             final errors = _validateFields(appTrans);
//                             if (errors.isNotEmpty) {
//                               _showFillAllFieldsSnack(appTrans);
//                               return;
//                             }
//                             final sections =
//                                 _buildTechnicianReviewSections(appTrans);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => GenericReviewScreen(
//                                   pageTitle: _isEditing
//                                       ? (appTrans?.text(
//                                               'review.technician_edit_page_title') ??
//                                           'Review Ad Modification')
//                                       : (appTrans?.text(
//                                               'review.technician_page_title') ??
//                                           'Review Technician Ad'),
//                                   sections: sections,
//                                   requireAgreement: true,
//                                   confirmLabel: _isEditing
//                                       ? (appTrans
//                                               ?.text('action.confirm_save') ??
//                                           'Confirm and Save')
//                                       : (appTrans?.text(
//                                               'action.confirm_publish') ??
//                                           'Confirm and Publish'),
//                                   onConfirm: () async {
//                                     Navigator.pop(context);
//                                     await _submitAd(appTrans);
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
