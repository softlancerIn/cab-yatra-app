import 'package:get/get.dart';
import '../core/network_service.dart';
import '../models/cmsPages_model.dart';

class CmsPageController extends GetxController {
  NetworkService service = NetworkService();
  var cmsPageData = CmsPageModel(
    aboutUs: '',
    termCondition: '',
    privacyPolicy: '',
    penalty: '',
    slaAgreements: '',
    refundPolicy: '',
  ).obs;

  Future<void> fetchCmsPage() async {
    final data = await service.getCmsPage();
    if (data != null) {
      cmsPageData.value = data;
      print('CMS Page Data fetched successfully: ${cmsPageData.value}');
    } else {
      print('Failed to fetch CMS page data');
    }
  }
}