import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/cms_bloc.dart';
import '../bloc/cms_event.dart';
import '../bloc/cms_state.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
      backgroundColor: Colors.white,
      appBar: const AppBAR(
        title: "About Us",
        showLeading: true,
        showAction: true,
      ),
      // appBar: AppBar(
      //   title: const Text("About Us Pages"),
      // ),

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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            children: [
              /// ABOUT US
              _cmsContent(
                "About Us",
                cms.aboutUs ?? "",
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cmsContent(String title, String htmlContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        Html(
          data: htmlContent,
          style: {
            "body": Style(
              fontSize: FontSize(14),
              lineHeight: const LineHeight(1.5),
              color: Colors.black87,
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
          },
        ),
      ],
    );
  }
}
