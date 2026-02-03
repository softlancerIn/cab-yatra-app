import 'dart:io';

import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network_service.dart';
import '../../models/dirver_payment_method.dart';

class PaymentMode extends StatefulWidget {
  @override
  _PaymentModeState createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> with TickerProviderStateMixin {
  TabController? _tabController;

  final _bankFormKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reAccountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountHolderController = TextEditingController();

  final _upiIdController = TextEditingController();
  final _paymentNumberController = TextEditingController();
  File? _qrImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPaymentMethodData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _qrImage = File(image.path);
      });
    }
  }
  Future<void> _fetchPaymentMethodData() async {
    DriverPaymentMethod? paymentMethod = await NetworkService().getPayementMethodData();
    if (paymentMethod != null && paymentMethod.status == true) {
      if (paymentMethod.data != null) {
        PayMethodData methodData = paymentMethod.data!;
          _tabController!.index = 0;
          _bankNameController.text = methodData.bankName ?? '';
          _accountNumberController.text = methodData.accountNumber ?? '';
          _ifscCodeController.text = methodData.ifscCode ?? '';
          _accountHolderController.text = methodData.accountHolderName ?? '';
          _upiIdController.text = methodData.upiId ?? '';
          _paymentNumberController.text = methodData.paymentNumber ?? '';
          _qrImage = File(methodData.qrImage??'');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load payment method data')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _saveForm() {
    if (_tabController!.index == 0) {
      if (_bankFormKey.currentState!.validate()) {
        String paymentType = "1"; // Bank
        PayMethodData paymentData = PayMethodData(
          type: paymentType,
          bankName: _bankNameController.text,
          accountNumber: _accountNumberController.text,
          ifscCode: _ifscCodeController.text,
          accountHolderName: _accountHolderController.text,
          upiId: _upiIdController.text.isNotEmpty ? _upiIdController.text : null,
          paymentNumber: _paymentNumberController.text.isNotEmpty ? _paymentNumberController.text : null,
        );

        NetworkService().postPaymentMethod(paymentData).then((response) {
          if (response != null && response.status == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment method saved successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save payment method: ${response?.message}')),
            );
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all bank details correctly')),
        );
      }
    } else {
      if (_upiIdController.text.isNotEmpty && _paymentNumberController.text.isNotEmpty) {
        String paymentType = "0";
        PayMethodData paymentData = PayMethodData(
          type: paymentType,
          bankName: _bankNameController.text.isNotEmpty ? _bankNameController.text : null,
          accountNumber: _accountNumberController.text.isNotEmpty ? _accountNumberController.text : null,
          ifscCode: _ifscCodeController.text.isNotEmpty ? _ifscCodeController.text : null,
          accountHolderName: _accountHolderController.text.isNotEmpty ? _accountHolderController.text : null,
          upiId: _upiIdController.text,
          paymentNumber: _paymentNumberController.text,
        );

        NetworkService().uploadQR(qrImagePath: _qrImage?.path ?? '', paymentData: paymentData).then((response)
        {
          // if (response != null && response.status == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment method saved successfully!')),
            );
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Failed to save payment method: ${response?.message}')),
          //   );
          // }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill UPI and Payment Number details correctly')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          AppBAR(title: "Payment Method"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
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
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs: [
                        Tab(text: 'Add Bank details'),
                        Tab(text: 'Add UPI'),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: TabBarView(
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
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    width: size.width * 1,
                                    height: size.height * 0.59,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 8,
                                          offset: Offset(1, 1),
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildTextField('Bank Name', _bankNameController, TextInputType.text),
                                        _buildTextField('Account Number', _accountNumberController, TextInputType.phone),
                                        _buildTextField('Re Account Number', _reAccountNumberController, TextInputType.phone),
                                        _buildTextField('IFSC Code', _ifscCodeController, TextInputType.text),
                                        _buildTextField('Account Holder Name', _accountHolderController, TextInputType.text),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text('* Please fill proper details', style: TextStyle(color: Colors.red)),
                                  SizedBox(height: 50),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ElevatedButton(
                                      onPressed: _saveForm,
                                      child: Container(
                                        width: size.width * 0.9,
                                        height: size.height * 0.03,
                                        child: Center(
                                          child: Text('Save', style: TextStyle(fontSize: 16,  color: Colors.white)),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                _buildTextField('UPI ID', _upiIdController, TextInputType.text),
                                SizedBox(height: 10),
                                Text('OR', style: TextStyle(color: Colors.black)),
                                _buildTextField('Payment Number', _paymentNumberController, TextInputType.text),
                                SizedBox(height: 10),
                                Text('OR', style: TextStyle(color: Colors.black)),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          width: 114,
                                          height: 114,
                                          color: Color(0xFFDADADA),
                                          child: Padding(
                                              padding: const EdgeInsets.all(28),
                                              child:
                                              Image.asset('assets/images/driver_upload_logo.png', height: 20, fit: BoxFit.fitHeight)
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text('+ Upload Your UPI QR Photo'),
                                      SizedBox(height: 10),
                                      Image.asset('assets/images/qr_code.png', height: 100),
                                      SizedBox(height: 55),
                                      ElevatedButton(
                                        onPressed: _saveForm,
                                        child: Container(
                                          width: size.width * 0.9,
                                          height: size.height * 0.03,
                                          child: Center(
                                            child: Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType, {String? hintText = '', IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          labelText: label,
          hintText: hintText,
          focusColor: Color.fromRGBO(0, 0, 0, 0.5),
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == 'Re Account Number' && value != _accountNumberController.text) {
            return 'Account numbers do not match';
          }
          return null;
        },
      ),
    );
  }
}