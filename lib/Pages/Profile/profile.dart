
import 'package:cab_taxi_app/Pages/AuthPages/login/ui/loginScreen.dart';
import 'package:cab_taxi_app/Pages/Profile/profileDetail_screen.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:flutter/material.dart';

import 'package:cab_taxi_app/Pages/Mohnish_Sir/html_data_page.dart';

import 'package:cab_taxi_app/Pages/Payment%20Method/payment_method.dart';
import 'package:cab_taxi_app/Pages/Support/support.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/profile_controller.dart';
import '../../app/router/navigation/nav.dart';
import '../../core/utils/helperFunctions.dart';
import '../../cores/services/secure_storage_service.dart';
import '../Custom_Widgets/custom_text_button.dart';
import '../Review/reviews_list.dart';




class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  bool isSettingExpanded = false;
  @override
  void initState() {
    super.initState();
    controller.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                final profile = controller.profileData.value.data;
                Get.to(() => ReviewList(
                  profileName: profile?.name ?? 'Unknown',
                  profileEmail: profile?.email ?? 'No Email',
                  profileImageUrl: profile?.driverImageUrl ?? 'assets/images/profile_sample.png',
                ));
              },
              child: Container(
                width: width,
                height: 200,
                color: Colors.black,
                child: Stack(
                  children: [
                    Center(
                      child: Obx(() {
                        if (controller.profileLoading.value) {
                          return  CircularProgressIndicator();
                        }
                        final profile = controller.profileData.value.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),
                            CircleAvatar(
                              foregroundImage: NetworkImage(profile?.driverImageUrl ?? 'assets/images/profile_sample.png'),
                              maxRadius: 50,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(profile?.name ?? 'Unknown', style: TextStyle(fontSize: 12, color: Colors.white)),
                                SizedBox(width:width*0.01 ),
                                Container(
                                  width: size.width * 0.04,
                                  height: size.height * 0.025,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 216, 0, 1),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/star.png', scale: 5),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(profile?.email ?? 'No Email', style: TextStyle(fontSize: 10, color: Colors.white)),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: width,
                child: Column(
                  children: [
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/profileIcon.png'), height: size.height * 0.025),
                      title: const Text('Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => ProfileDetails(
                        ));
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/wallet.png'), height: size.height * 0.025),
                      title: const Text('Wallet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        // Get.to(() => const WalletPage());
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/penalty.png'), height: size.height * 0.025),
                      title: const Text('Penalty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const HtmlDataPage(title: "Penalty", section: "Penalty"));
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/payment_mode.png'), height: size.height * 0.025),
                      title: const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => PaymentMode());
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/refund.png'), height: size.height * 0.025),
                      title: const Text('Refund Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const HtmlDataPage(title: "Refund Policy", section: "Refund Policy"));
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/support.png'), height: size.height * 0.025),
                      title: const Text('Help & Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const SupportScreennn());
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/about.png'), height: size.height * 0.025),
                      title: const Text('About us', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const HtmlDataPage(title: "About Us", section: "About Us"));
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/privacy.png'), height: size.height * 0.025),
                      title: const Text('Privacy Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const HtmlDataPage(title: "Privacy Policy", section: "Privacy Policy"));
                      },
                    ),
                    ListTile(
                      leading: Image(image: AssetImage('assets/images/t&c.png'), height: size.height * 0.025),
                      title: const Text('Terms & Conditions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      onTap: () {
                        Get.to(() => const HtmlDataPage(title: "Terms & Conditions", section: "Terms & Conditions"));
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.logout_outlined, size: 20, color: Color.fromRGBO(255, 0, 0, 1)),
                    //   title: const Text('Logout', style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500)),
                    //   onTap: () async {
                    //     SharedPreferences prefs = await SharedPreferences.getInstance();
                    //     await prefs.remove('auth_token');
                    //     Get.offAll(const OtpPage());
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.logout_outlined, size: 20, color: Color.fromRGBO(255, 0, 0, 1)),
                      title: const Text('Logout', style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500)),
                      onTap: () async {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text('Confirm Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                CustomTextButton(
                                  title:'Cancel',
                                  color:Colors.transparent,
                                  textColor:const Color(0xFFFFB900),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CustomTextButton(
                                    title:'Logout',
                                    color:const Color(0xFFFFB900),
                                    textColor:Colors.white,
                                    onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.remove('auth_token');
                                 SecureStorageService.logout(context);
                                    // Nav.go(context,Routes.login);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, size: 20,),
                      title: const Text('Setting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      trailing: Icon(
                        isSettingExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black,
                      ),
                      onTap: () {
                        setState(() {
                          isSettingExpanded = !isSettingExpanded;
                        });
                      },
                    ),

                    // Show submenu only if expanded
                    if (isSettingExpanded)
                      Padding(
                        padding: EdgeInsets.only(left: 40), // indent submenu
                        child: ListTile(
                          title: const Text(
                            'Delete Account',
                             style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            const url = 'https://cabyatra.com/delete-account';
                            await HelperFunctions.launchExternalUrl(url);
                          },
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              const phoneNumber = '9911995523';
                              const url = 'https://wa.me/$phoneNumber';
                              await HelperFunctions.launchExternalUrl(url);
                            },
                            child: Image(image: const AssetImage('assets/images/whatsapp.png'), height: size.height * 0.04),
                          ),
                          SizedBox(width: size.width * 0.01,),
                          GestureDetector(onTap:() async {
                            const url = 'https://www.instagram.com/cabyatra/';
                            await HelperFunctions.launchExternalUrl(url);
                          },
                              child:Image(image:const AssetImage('assets/images/instagram.png'), height: size.height * 0.04)),
                          SizedBox(width: size.width * 0.01,),
                          Image(image: AssetImage('assets/images/facebook.png'), height: size.height * 0.04),
                          // Image(image: AssetImage('assets/images/linkedin.png'), height: size.height * 0.04),
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
    );
  }
}
