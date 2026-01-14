import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/companydetails/presentation/cubit/companydetailes_cubit.dart';
import 'package:oreed_clean/features/companydetails/presentation/cubit/companydetailes_state.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/company_detailes_body.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/empty_view.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/shimmer_company.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final int companyId;
  final int sectionId;
  final String? searchText;

  const CompanyDetailsScreen({
    super.key,
    required this.companyId,
    required this.sectionId,
    this.searchText,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _userId = AppSharedPreferences().getUserIdD() ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyDetailsCubit>().fetchCompanyData(
        widget.companyId,
        widget.sectionId,
        searchText: widget.searchText,
      );
    });
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
        builder: (context, state) {
          if (state.status == CompanyDetailsStatus.loading) {
            return Shimmercompany();
          }

          if (state.status == CompanyDetailsStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Error"));
          }

          if (state.company == null) {
            return Emptyview(context: context);
          }

          return CompanyDetailsBody(
            company: state.company!,
            ads: state.ads,
            sectionId: widget.sectionId,
            userId: _userId,
            onCall: _callPhone,
            onWhatsApp: _openWhatsApp,
            onOpenUrl: _openUrl,
          );
        },
      ),
    );
  }
}
