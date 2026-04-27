import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/personal_info_bloc.dart';
import 'bloc/personal_info_event.dart';
import 'bloc/personal_info_state.dart';
import 'package:cab_taxi_app/Pages/Review/bloc/review_bloc.dart';
import 'package:cab_taxi_app/Pages/Review/bloc/review_event.dart';
import 'package:cab_taxi_app/Pages/Review/bloc/review_state.dart';
import '../../cores/services/secure_storage_service.dart';
import '../Custom_Widgets/service_call_dialog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // final ProfileController controller = Get.put(ProfileController());
  bool isSettingExpanded = false;
  @override
  void initState() {
    super.initState();
    context.read<PersonalInfoBloc>().add(LoadProfile(context));
    context.read<ReviewBloc>().add(LoadReviews(context));
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E4959),
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                /// Message with Blue Underline
                const Text(
                  "Are you sure you want to Logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF3E4959),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 35),

                /// Buttons
                Row(
                  children: [
                    /// Go back Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E4959),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "Go back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// Logout Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await SecureStorageService.logout(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF45858),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<PersonalInfoBloc>().add(LoadProfile(context));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LogOutButton(
                      title: 'Logout',
                      image: 'assets/images/logoutIcon.png',
                      onTap: () {
                        showLogoutDialog(context);
                      }),
                  LogOutButton(
                      title: 'Help',
                      image: 'assets/images/helpIcon.png',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const ServiceCallDialog(),
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<PersonalInfoBloc, PersonalInfoState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const SizedBox(
                        height: 400,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  50), // adjust for more/less roundness
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFFFCB117),
                                  ),
                                  // borderRadius: BorderRadius.circular(50),  // optional if not using ClipRRect
                                ),
                                child: Image.network(
                                  state.networkImage ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[100],
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Color(0xFFFCB117),
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                Color(0xFFFCB117)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              state.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                            Text(
                              state.phone,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins'),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<ReviewBloc, ReviewState>(
                              builder: (context, reviewState) {
                                final averageRating = reviewState.reviewModel?.averageRating?.toString() ?? state.rating;
                                final totalReviews = reviewState.reviewModel?.totalReviews?.toString() ?? state.ratingCount;

                                return GestureDetector(
                                  onTap: () {
                                    Nav.push(context, Routes.reviewScreen);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    children: [
                                      Text(
                                        averageRating,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFFCB117),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '($totalReviews review)',
                                        style: const TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 11,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                      ],
                    );
                  }),
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              titleData(title: 'Account'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () async {
                    await Nav.push(context, Routes.profile);
                    if (mounted) {
                      context.read<PersonalInfoBloc>().add(LoadProfile(context));
                    }
                  },
                  image: 'assets/images/personalIcon.png',
                  title: 'Personal Information'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.manageDrivers);
                  },
                  image: 'assets/images/ManageDriver.png',
                  title: 'Manage Drivers'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.manageVehicles);
                  },
                  image: 'assets/images/manageVahical.png',
                  title: 'Manage Vehicles'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.paymentMethod);
                  },
                  image: 'assets/images/paymentVahical.png',
                  title: 'Payment Methods'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(
                      context,
                      Routes.transection,
                    );
                  },
                  image: 'assets/images/BookingIcon.png',
                  title: 'Booking Transactions'),
              const SizedBox(
                height: 10,
              ),
              titleData(title: 'Policies'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.aboutus);
                  },
                  image: 'assets/images/aboutUs.png',
                  title: 'About Us'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.privacyPolicy);
                  },
                  image: 'assets/images/privacyPolicy.png',
                  title: 'Privacy Policy'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.termsCondition);
                  },
                  image: 'assets/images/termsIcon.png',
                  title: 'Term & Conditions'),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchURL("https://www.youtube.com/@cab_yatra");
                    },
                    child: Image.asset(
                      'assets/images/youtubeee.png',
                      height: 27,
                      width: 27,
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      launchURL("https://www.instagram.com/cabyatra/");
                    },
                    child: Image.asset(
                      'assets/images/instagram.png',
                      height: 27,
                      width: 27,
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      launchURL("https://www.facebook.com/share/15gpYtg4uG/");
                    },
                    child: Image.asset(
                      'assets/images/facebook.png',
                      height: 27,
                      width: 27,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),
      ),
    ),
  );
}


  Widget titleCardData({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4B4B4B)),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFFCB117),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget LogOutButton({
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32, // Consistent with AppBar pills
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xFFEFEFEF),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13, // Increased from 12
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Image(
              image: AssetImage(image),
              height: 18,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleData({
    required String title,
    TextAlign? textAlign = TextAlign.center,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
      ),
    );
  }
}
