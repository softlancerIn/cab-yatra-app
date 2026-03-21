import 'dart:io';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widget/customTextField.dart';
import '../../../widget/primary_button.dart';
import '../bloc/paymentBloc.dart';
import '../bloc/paymentEvent.dart';
import '../bloc/paymentState.dart';
import '../../../cores/services/secure_storage_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  final _bankFormKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reAccountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountHolderController = TextEditingController();

  final _upiIdController = TextEditingController();
  final _paymentNumberController = TextEditingController();

  String? _driverId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDriverId();
    context.read<PaymentBloc>().add(LoadPayment());
  }

  Future<void> _loadDriverId() async {
    final id = await SecureStorageService.getUserId();
    setState(() {
      _driverId = id;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _reAccountNumberController.dispose();
    _ifscCodeController.dispose();
    _accountHolderController.dispose();
    _upiIdController.dispose();
    _paymentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBAR(
          title: "Payment Method", showLeading: true, showAction: false),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment Updated Successfully")),
            );
          }

          if (state.loaded && state.payment?.data?.isNotEmpty == true) {
            final firstPayment = state.payment!.data!.first;
            print("--- PAYMENT DATA LOADED ---");
            print("Bank: ${firstPayment.bankName}");
            print("Acc: ${firstPayment.accountNumber}");
            
            _bankNameController.text = firstPayment.bankName ?? "";
            _accountNumberController.text = firstPayment.accountNumber ?? "";
            _reAccountNumberController.text = firstPayment.accountNumber ?? "";
            _ifscCodeController.text = firstPayment.ifscCode ?? "";
            _accountHolderController.text = firstPayment.accountHolderName ?? "";
            _upiIdController.text = firstPayment.upiId ?? "";
            _paymentNumberController.text = firstPayment.paymentNumber ?? "";

            // If bank data exists, default to Bank tab (index 1)
            if (firstPayment.bankName != null && firstPayment.bankName!.isNotEmpty) {
              if (_tabController?.index == 0) {
                _tabController?.animateTo(1);
              }
            }
          }
        },
        builder: (context, state) {
          if (state.loading && state.payment == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Tab Switcher
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: const Color(0xffFCB117),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: const Color(0xFFAAAAAA),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          tabs: const [
                            Tab(text: "Add UPI"),
                            Tab(text: "Bank Details"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Tab Content
                      SizedBox(
                        height: 520,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            /// UPI VIEW
                            _buildUpiSection(state),

                            /// BANK VIEW
                            _buildBankSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// BOTTOM ACTION
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: CommonAppButton(
                  text: "Update",
                  isLoading: state.loading,
                  height: 56,
                  borderRadius: 14,
                  backgroundColor: const Color(0xffFCB117),
                  onPressed: () => _handleSubmit(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpiSection(PaymentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add UPI",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xff444444))),
        const SizedBox(height: 18),
        CommonTextFormField(
            hintText: 'Enter Payment Number',
            controller: _paymentNumberController,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 14),
        const Center(
            child: Text("OR",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff666666),
                    fontFamily: 'Poppins'))),
        const SizedBox(height: 14),
        CommonTextFormField(
            hintText: 'Add Upi ID',
            controller: _upiIdController,
            keyboardType: TextInputType.text),
        const SizedBox(height: 28),
        const Text("+ Upload Your QR Photo",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xff444444))),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.read<PaymentBloc>().add(PickQrImage()),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
            ),
            child: state.qrImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      state.qrImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/qr_code.png',
                          fit: BoxFit.cover),
                    ),
                  )
                : state.payment?.data?.isNotEmpty == true &&
                        state.payment!.data!.first.qrImageUrl != null &&
                        state.payment!.data!.first.qrImageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          state.payment!.data!.first.qrImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/qr_code.png',
                                  fit: BoxFit.cover),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/qr_code.png',
                          fit: BoxFit.cover,
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankSection() {
    return Form(
      key: _bankFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bank Details",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xff444444))),
          const SizedBox(height: 18),
          CommonTextFormField(
              hintText: 'Bank Name',
              controller: _bankNameController,
              validator: (value) =>
                  value?.isEmpty == true ? 'Bank name is required' : null),
          const SizedBox(height: 15),
          CommonTextFormField(
              hintText: 'Account Number',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty == true ? 'Account number is required' : null),
          const SizedBox(height: 15),
          CommonTextFormField(
              hintText: 'Re Account Number',
              controller: _reAccountNumberController,
              keyboardType: TextInputType.number),
          const SizedBox(height: 15),
          CommonTextFormField(
              hintText: 'IFSC Code',
              controller: _ifscCodeController,
              validator: (value) =>
                  value?.isEmpty == true ? 'IFSC code is required' : null),
          const SizedBox(height: 15),
          CommonTextFormField(
              hintText: 'Account Holder name',
              controller: _accountHolderController,
              validator: (value) => value?.isEmpty == true
                  ? 'Account holder name is required'
                  : null),
          const SizedBox(height: 22),
          const Row(
            children: [
              Text("• ",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text("Please fill proper details",
                  style: TextStyle(
                      color: Colors.red, fontSize: 14, fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_tabController?.index == 1) {
      if (!_bankFormKey.currentState!.validate()) return;
      if (_accountNumberController.text != _reAccountNumberController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account numbers do not match")),
        );
        return;
      }
    }

    final bloc = context.read<PaymentBloc>();
    final isBankTab = _tabController?.index == 1;

    if (isBankTab) {
      final fields = {
        "driver_id": _driverId ?? "0",
        "type": "1",
        "bank_name": _bankNameController.text,
        "account_number": _accountNumberController.text,
        "ifsc_code": _ifscCodeController.text,
        "account_holderName": _accountHolderController.text,
      };
      bloc.add(SubmitPayment(fields: fields, files: {}));
    } else {
      final fields = {
        "driver_id": _driverId ?? "0",
        "type": "0",
        "upi_id": _upiIdController.text,
        "payment_number": _paymentNumberController.text,
      };
      final files = <String, File>{};
      if (bloc.state.qrImage != null) {
        files["qr_image"] = bloc.state.qrImage!;
      }
      bloc.add(SubmitPayment(fields: fields, files: files));
    }
  }
}
