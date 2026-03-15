import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/cms_bloc.dart';
import '../bloc/cms_event.dart';
import '../bloc/cms_state.dart';

class TermsConditionPage extends StatefulWidget {
  const TermsConditionPage({super.key});

  @override
  State<TermsConditionPage> createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends State<TermsConditionPage> {

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
      appBar: AppBAR(title: "Terms Condition",showLeading: true,showAction: true,),


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


              /// TERMS
              _cmsCard(
                "Terms & Conditions",
                cms.termCondition ?? "",
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