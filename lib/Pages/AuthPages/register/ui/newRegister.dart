import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/registerBloc.dart';
import '../bloc/registerEvent.dart';
import '../bloc/registerState.dart';
// import 'register_bloc.dart'; // adjust path
// import your models if needed: VerifyOtpResponse, etc.

class NewRegisterScreen extends StatefulWidget {
  final String mobile;
  const NewRegisterScreen({super.key, required this.mobile});

  @override
  State<NewRegisterScreen> createState() => _NewRegisterScreenState();
}

class _NewRegisterScreenState extends State<NewRegisterScreen> {
  late final TextEditingController _mobileController;
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _otpController;

  final _formKey = GlobalKey<FormState>();

  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.mobile);
    _nameController = TextEditingController();
    _cityController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Common TextField Widget
  Widget _textField({
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isLoading) {
          // optional: show full-screen loading
        }

        if (state.hasError && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Registration successful!"),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to home / main screen
          // Navigator.pushReplacementNamed(context, '/home');
          // or: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button (optional)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/finalLogooo.png",
                            scale: 5,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Title
                    const Text(
                      'Verify With OTP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.40,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mobile (pre-filled & disabled)
                    _textField(
                      hint: 'Mobile Number',
                      controller: _mobileController,
                      enabled: false,
                    ),

                    const SizedBox(height: 14),

                    // Full Name
                    _textField(
                      hint: 'Enter Full Name',
                      controller: _nameController,
                      validator: (v) => v?.trim().isEmpty ?? true ? 'Name is required' : null,
                    ),

                    const SizedBox(height: 14),

                    // City
                    _textField(
                      hint: 'Enter City Name',
                      controller: _cityController,
                      validator: (v) => v?.trim().isEmpty ?? true ? 'City is required' : null,
                    ),

                    const SizedBox(height: 14),

                    // OTP
                    _textField(
                      hint: 'Enter OTP',
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v?.length ?? 0) < 4 ? 'Enter valid 4-digit OTP' : null,
                    ),

                    const SizedBox(height: 12),

                    // Resend OTP
                    Center(
                      child: TextButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                          // TODO: call resend OTP API
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resend OTP clicked')),
                          );
                        },
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Terms Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: state.isLoading
                              ? null
                              : (value) {
                            setState(() => _termsAccepted = value ?? false);
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: 13),
                              children: [
                                TextSpan(text: 'By clicking here accept '),
                                TextSpan(
                                  text: 'Terms of Use',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: state.isLoading || !_termsAccepted
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterBloc>().add(
                              RegisterSummitedEvent(
                                mobile: _mobileController.text.trim(),
                                otp: _otpController.text.trim(),
                                name: _nameController.text.trim(),
                                city: _cityController.text.trim(),
                                context: context,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}