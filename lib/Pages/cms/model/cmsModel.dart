class CmsModel {
  String? aboutUs;
  String? termCondition;
  String? privacyPolicy;
  String? penalty;
  String? slaAgreements;
  String? refundPolicy;

  CmsModel({
    this.aboutUs,
    this.termCondition,
    this.privacyPolicy,
    this.penalty,
    this.slaAgreements,
    this.refundPolicy,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    return CmsModel(
      aboutUs: json['about_us'],
      termCondition: json['term_condition'],
      privacyPolicy: json['privacy_policy'],
      penalty: json['penalty'],
      slaAgreements: json['sla_agreements'],
      refundPolicy: json['refund_policy'],
    );
  }
}