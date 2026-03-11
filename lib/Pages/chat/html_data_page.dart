import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/cmsPages_controller.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlDataPage extends StatefulWidget {
  final String title;
  final String section;

  const HtmlDataPage({super.key, required this.title, required this.section});

  @override
  State<HtmlDataPage> createState() => _HtmlDataPageState();
}

class _HtmlDataPageState extends State<HtmlDataPage> {
  final CmsPageController controller = Get.put(CmsPageController());

  @override
  void initState() {
    super.initState();
    controller.fetchCmsPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios_new),
            onTap: () {
              Get.back();
            }),
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [Image.asset("assets/images/car_icon_n.png")],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final cmsData = controller.cmsPageData.value;
          String content;
          switch (widget.section) {
            case 'About Us':
              content = cmsData.aboutUs;
              break;
            case 'Terms & Conditions':
              content = cmsData.termCondition;
              break;
            case 'Privacy Policy':
              content = cmsData.privacyPolicy;
              break;
            case 'Penalty':
              content = cmsData.penalty;
              break;
            case 'SLA Agreement':
              content = cmsData.slaAgreements;
              break;
            case 'Refund Policy':
              content = cmsData.refundPolicy;
              break;
            default:
              content = 'No content available';
          }
          print('Content for ${widget.section}: $content');
          return SingleChildScrollView(
            child: content.isNotEmpty
                ? Html(
                    data: content,
                    style: {
                      "p": Style(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: FontSize(14),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        }),
      ),
    );
  }
}
