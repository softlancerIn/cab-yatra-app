
class CmsPageModel {
  final String aboutUs;
  final String termCondition;
  final String privacyPolicy;
  final String penalty;
  final String slaAgreements;
  final String refundPolicy;

  CmsPageModel({
    required this.aboutUs,
    required this.termCondition,
    required this.privacyPolicy,
    required this.penalty,
    required this.slaAgreements,
    required this.refundPolicy,
  });

  factory CmsPageModel.fromJson(Map<String, dynamic> json) {
    print('Parsing CMS Page Model from JSON: $json');
    String aboutUsContent = json['about_us'] ?? '';
    print('Parsed aboutUs content: $aboutUsContent');
    return CmsPageModel(
      aboutUs: json['about_us'] ?? '',
      termCondition: json['term_condition'] ?? '',
      privacyPolicy: json['privacy_policy'] ?? '',
      penalty: json['penalty'] ?? '',
      slaAgreements: json['sla_agreements'] ?? '',
      refundPolicy: json['refund_policy'] ?? '',
    );
  }
}