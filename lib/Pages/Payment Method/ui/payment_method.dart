import 'dart:io';

import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/customTextField.dart';
import '../bloc/paymentBloc.dart';
import '../bloc/paymentEvent.dart';
import '../bloc/paymentState.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    context.read<PaymentBloc>().add(LoadPayment());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        children: [
          const AppBAR(title: "Payment Method"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(1, 1),
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      automaticIndicatorColorAdjustment: false,
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      dividerHeight: 0,
                      indicator: BoxDecoration(
                        color: const Color(0xffFCB117),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs: const [
                        Tab(text: 'Add Bank details'),
                        Tab(text: 'Add UPI'),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: BlocConsumer<PaymentBloc, PaymentState>(
                        listener: (context, state) {
                      // Keep only success message + debug prints here
                      if (state.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Payment Saved Successfully")),
                        );
                      }

                      // Keep your debug prints...
                      print("======== PAYMENT STATE ========");
                      print("Success: ${state.success}");
                      // ... rest of your prints
                    }, builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // ── Get first payment (safe access) ──
                      final firstPayment =
                          state.payment?.data?.isNotEmpty == true
                              ? state.payment!.data!.first
                              : null;

                      // ── Prefill ONLY if controllers are still empty ──
                      // This prevents overwriting user typing
                      if (firstPayment != null) {
                        // Bank tab
                        if (_bankNameController.text.isEmpty) {
                          _bankNameController.text =
                              firstPayment.bankName ?? "";
                        }
                        if (_accountNumberController.text.isEmpty) {
                          _accountNumberController.text =
                              firstPayment.accountNumber ?? "";
                        }
                        if (_ifscCodeController.text.isEmpty) {
                          _ifscCodeController.text =
                              firstPayment.ifscCode ?? "";
                        }
                        if (_accountHolderController.text.isEmpty) {
                          _accountHolderController.text =
                              firstPayment.accountHolderName ?? "";
                        }

                        // UPI tab
                        if (_upiIdController.text.isEmpty) {
                          _upiIdController.text = firstPayment.upiId ?? "";
                        }
                        if (_paymentNumberController.text.isEmpty) {
                          _paymentNumberController.text =
                              firstPayment.paymentNumber ?? "";
                        }
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          // Bank Details Form
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              child: Form(
                                key: _bankFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 8,
                                            offset: Offset(1, 1),
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.15),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CommonTextFormField(
                                              hintText: 'Bank Name',
                                              controller: _bankNameController,
                                              keyboardType: TextInputType.text),
                                          const SizedBox(height: 10),
                                          CommonTextFormField(
                                              hintText: 'Account Number',
                                              controller:
                                                  _accountNumberController,
                                              keyboardType:
                                                  TextInputType.phone),
                                          const SizedBox(height: 10),
                                          CommonTextFormField(
                                              hintText: 'Re Account Number',
                                              controller:
                                                  _reAccountNumberController,
                                              keyboardType:
                                                  TextInputType.phone),
                                          const SizedBox(height: 10),
                                          CommonTextFormField(
                                              hintText: 'IFSC Code',
                                              controller: _ifscCodeController,
                                              keyboardType: TextInputType.text),
                                          const SizedBox(height: 10),
                                          CommonTextFormField(
                                              hintText: 'Account Holder Name',
                                              controller:
                                                  _accountHolderController,
                                              keyboardType: TextInputType.text),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text('* Please fill proper details',
                                        style: TextStyle(color: Colors.red)),
                                    const SizedBox(height: 50),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final fields = {
                                            "driver_id": "26",
                                            "type": "1",
                                            "bank_name":
                                                _bankNameController.text,
                                            "account_number":
                                                _accountNumberController.text,
                                            "ifsc_code":
                                                _ifscCodeController.text,
                                            "account_holderName":
                                                _accountHolderController.text,
                                          };

                                          context.read<PaymentBloc>().add(
                                                SubmitPayment(
                                                  fields: fields,
                                                  files: {},
                                                ),
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 100, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        child: SizedBox(
                                          width: size.width * 0.9,
                                          height: size.height * 0.03,
                                          child: const Center(
                                            child: Text('Save',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CommonTextFormField(
                                      hintText: 'UPI ID',
                                      controller: _upiIdController,
                                      keyboardType: TextInputType.text),
                                  const SizedBox(height: 10),
                                  const Text('OR',
                                      style: TextStyle(color: Colors.black)),
                                  CommonTextFormField(
                                      hintText: 'Payment Number',
                                      controller: _paymentNumberController,
                                      keyboardType: TextInputType.text),
                                  const SizedBox(height: 10),
                                  const Text('OR',
                                      style: TextStyle(color: Colors.black)),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<PaymentBloc>()
                                          .add(PickQrImage());
                                    },
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 114,
                                            height: 114,
                                            color: const Color(0xFFDADADA),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(28),
                                                child: Image.asset(
                                                    'assets/images/driver_upload_logo.png',
                                                    height: 20,
                                                    fit: BoxFit.fitHeight)),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                            '+ Upload Your UPI QR Photo'),
                                        const SizedBox(height: 10),
                                        state.qrImage != null
                                            ? Image.file(
                                                state.qrImage!,
                                                height: 100,
                                              )
                                            : Image.network(
                                                state.payment?.data
                                                            ?.isNotEmpty ==
                                                        true
                                                    ? (state.payment!.data!
                                                            .first.qrImageUrl ??
                                                        "")
                                                    : "",
                                                height: 100,

                                                /// 🔥 Agar network image load na ho
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/qr_code.png',
                                                    height: 100,
                                                  );
                                                },

                                                /// 🔥 Agar URL empty ho to bhi fallback
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Image.asset(
                                                    'assets/images/qr_code.png',
                                                    height: 100,
                                                  );
                                                },
                                              ),
                                        const SizedBox(height: 55),
                                        ElevatedButton(
                                          onPressed: () {
                                            final bloc =
                                                context.read<PaymentBloc>();

                                            final fields = {
                                              "driver_id": "26",
                                              "type": "2",
                                              "upi_id": _upiIdController.text,
                                              "payment_number":
                                                  _paymentNumberController.text,
                                            };

                                            final files = <String, File>{};

                                            if (bloc.state.qrImage != null) {
                                              files["qr_image"] =
                                                  bloc.state.qrImage!;
                                            }

                                            bloc.add(
                                              SubmitPayment(
                                                fields: fields,
                                                files: files,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 100, vertical: 15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: SizedBox(
                                            width: size.width * 0.9,
                                            height: size.height * 0.03,
                                            child: const Center(
                                              child: Text('Save',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
