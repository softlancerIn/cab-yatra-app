import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/cms_bloc.dart';
import '../bloc/cms_event.dart';
import '../bloc/cms_state.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {

  @override
  void initState() {
    super.initState();

    context.read<CmsBloc>().add(
      LoadCms(context),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBAR(title: "Privacy Policy",showLeading: true,showAction: true,),


      body: BlocBuilder<CmsBloc, CmsState>(
        builder: (context, state) {

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final cms = state.cms;

          if (cms == null) {
            return const Center(
              child: Text("No Data Found"),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [

              /// PRIVACY
              _cmsCard(
                "Privacy Policy",
                cms.privacyPolicy ?? "",
              ),

            ],
          );
        },
      ),
    );
  }

  Widget _cmsCard(String title, String htmlContent) {

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Html(
              data: htmlContent,
            ),

          ],
        ),
      ),
    );
  }
}