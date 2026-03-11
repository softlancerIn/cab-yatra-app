import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/personal_info_bloc.dart';
import 'bloc/personal_info_event.dart';
import 'bloc/personal_info_state.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LogOutButton(
                      title: 'Logout',
                      image: 'assets/images/logoutIcon.png',
                      onTap: () {}),
                  LogOutButton(
                      title: 'Help',
                      image: 'assets/images/helpIcon.png',
                      onTap: () {}),
                ],
              ),
              const SizedBox(
                height: 10,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                              state.name ?? 'Brijesh',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            //SizedBox(height: 5,),
                            Text(
                              state.phone ?? '6389716535',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Nav.push(context, Routes.reviewScreen);
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Color(0xFFFCB117),
                                    size: 16,
                                  ),
                                  // Icon(Icons.star,color:Color(0xFFFCB117) ,size: 16,),
                                  // Icon(Icons.star,color:Color(0xFFFCB117) ,size: 16,),
                                  // Icon(Icons.star,color:Color(0xFFFCB117) ,size: 16,),
                                  // Icon(Icons.star,color:Color(0xFFFCB117) ,size: 16,),
                                  Text(
                                    '(1 review)',
                                    style: TextStyle(
                                      color: Color(0xFF787878),
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }),

              const SizedBox(
                height: 10,
              ),
              titleData(title: 'Account'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {
                    Nav.push(context, Routes.profile);
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
                  onTap: () {},
                  image: 'assets/images/aboutUs.png',
                  title: 'About Us'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {},
                  image: 'assets/images/privacyPolicy.png',
                  title: 'Privacy Policy'),
              const SizedBox(
                height: 10,
              ),
              titleCardData(
                  onTap: () {},
                  image: 'assets/images/termsIcon.png',
                  title: 'Term & Conditions'),
              const SizedBox(
                height: 10,
              ),

              // GestureDetector(
              //   onTap: () {
              //     final profile = controller.profileData.value.data;
              //     Get.to(() => ReviewList(
              //       profileName: profile?.name ?? 'Unknown',
              //       profileEmail: profile?.email ?? 'No Email',
              //       profileImageUrl: profile?.driverImageUrl ?? 'assets/images/profile_sample.png',
              //     ));
              //   },
              //   child: Container(
              //     width: width,
              //     height: 200,
              //     color: Colors.black,
              //     child: Stack(
              //       children: [
              //         Center(
              //           child: Obx(() {
              //             if (controller.profileLoading.value) {
              //               return  CircularProgressIndicator();
              //             }
              //             final profile = controller.profileData.value.data;
              //             return Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 SizedBox(height: 40),
              //                 CircleAvatar(
              //                   foregroundImage: NetworkImage(profile?.driverImageUrl ?? 'assets/images/profile_sample.png'),
              //                   maxRadius: 50,
              //                 ),
              //                 Row(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(profile?.name ?? 'Unknown ss', style: TextStyle(fontSize: 12, color: Colors.white)),
              //                     SizedBox(width:width*0.01 ),
              //                     Container(
              //                       width: size.width * 0.04,
              //                       height: size.height * 0.025,
              //                       decoration: BoxDecoration(
              //                           color: const Color.fromRGBO(255, 216, 0, 1),
              //                           borderRadius: BorderRadius.circular(4)),
              //                       child: Row(
              //                         children: [
              //                           Image.asset('assets/images/star.png', scale: 5),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 Text(profile?.email ?? 'No Email', style: TextStyle(fontSize: 10, color: Colors.white)),
              //               ],
              //             );
              //           }),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Container(
              //     width: width,
              //     child: Column(
              //       children: [
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/profileIcon.png'), height: size.height * 0.025),
              //           title: const Text('Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => ProfileDetails(
              //             ));
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/wallet.png'), height: size.height * 0.025),
              //           title: const Text('Wallet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             // Get.to(() => const WalletPage());
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/penalty.png'), height: size.height * 0.025),
              //           title: const Text('Penalty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const HtmlDataPage(title: "Penalty", section: "Penalty"));
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/payment_mode.png'), height: size.height * 0.025),
              //           title: const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => PaymentMode());
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/refund.png'), height: size.height * 0.025),
              //           title: const Text('Refund Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const HtmlDataPage(title: "Refund Policy", section: "Refund Policy"));
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/support.png'), height: size.height * 0.025),
              //           title: const Text('Help & Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const SupportScreennn());
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/about.png'), height: size.height * 0.025),
              //           title: const Text('About us', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const HtmlDataPage(title: "About Us", section: "About Us"));
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/privacy.png'), height: size.height * 0.025),
              //           title: const Text('Privacy Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const HtmlDataPage(title: "Privacy Policy", section: "Privacy Policy"));
              //           },
              //         ),
              //         ListTile(
              //           leading: Image(image: AssetImage('assets/images/t&c.png'), height: size.height * 0.025),
              //           title: const Text('Terms & Conditions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           onTap: () {
              //             Get.to(() => const HtmlDataPage(title: "Terms & Conditions", section: "Terms & Conditions"));
              //           },
              //         ),
              //         // ListTile(
              //         //   leading: const Icon(Icons.logout_outlined, size: 20, color: Color.fromRGBO(255, 0, 0, 1)),
              //         //   title: const Text('Logout', style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500)),
              //         //   onTap: () async {
              //         //     SharedPreferences prefs = await SharedPreferences.getInstance();
              //         //     await prefs.remove('auth_token');
              //         //     Get.offAll(const OtpPage());
              //         //   },
              //         // ),
              //         ListTile(
              //           leading: const Icon(Icons.logout_outlined, size: 20, color: Color.fromRGBO(255, 0, 0, 1)),
              //           title: const Text('Logout', style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500)),
              //           onTap: () async {
              //             // Show confirmation dialog
              //             showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return AlertDialog(
              //                   backgroundColor: Colors.white,
              //                   title: const Text('Confirm Logout'),
              //                   content: const Text('Are you sure you want to logout?'),
              //                   actions: <Widget>[
              //                     CustomTextButton(
              //                       title:'Cancel',
              //                       color:Colors.transparent,
              //                       textColor:const Color(0xFFFFB900),
              //                       onPressed: () {
              //                         Navigator.of(context).pop();
              //                       },
              //                     ),
              //                     CustomTextButton(
              //                         title:'Logout',
              //                         color:const Color(0xFFFFB900),
              //                         textColor:Colors.white,
              //                         onPressed: () async {
              //                         SharedPreferences prefs = await SharedPreferences.getInstance();
              //                         await prefs.remove('auth_token');
              //                      SecureStorageService.logout(context);
              //                         // Nav.go(context,Routes.login);
              //                       },
              //                     )
              //                   ],
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //         ListTile(
              //           leading: const Icon(Icons.settings, size: 20,),
              //           title: const Text('Setting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              //           trailing: Icon(
              //             isSettingExpanded ? Icons.expand_less : Icons.expand_more,
              //             color: Colors.black,
              //           ),
              //           onTap: () {
              //             setState(() {
              //               isSettingExpanded = !isSettingExpanded;
              //             });
              //           },
              //         ),
              //
              //         // Show submenu only if expanded
              //         if (isSettingExpanded)
              //           Padding(
              //             padding: EdgeInsets.only(left: 40), // indent submenu
              //             child: ListTile(
              //               title: const Text(
              //                 'Delete Account',
              //                  style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1), fontSize: 16, fontWeight: FontWeight.w500),
              //               ),
              //               onTap: () async {
              //                 const url = 'https://cabyatra.com/delete-account';
              //                 await HelperFunctions.launchExternalUrl(url);
              //               },
              //             ),
              //           ),
              //
              //         Padding(
              //           padding: const EdgeInsets.all(30),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               GestureDetector(
              //                 onTap: () async {
              //                   const phoneNumber = '9911995523';
              //                   const url = 'https://wa.me/$phoneNumber';
              //                   await HelperFunctions.launchExternalUrl(url);
              //                 },
              //                 child: Image(image: const AssetImage('assets/images/whatsapp.png'), height: size.height * 0.04),
              //               ),
              //               SizedBox(width: size.width * 0.01,),
              //               GestureDetector(onTap:() async {
              //                 const url = 'https://www.instagram.com/cabyatra/';
              //                 await HelperFunctions.launchExternalUrl(url);
              //               },
              //                   child:Image(image:const AssetImage('assets/images/instagram.png'), height: size.height * 0.04)),
              //               SizedBox(width: size.width * 0.01,),
              //               Image(image: AssetImage('assets/images/facebook.png'), height: size.height * 0.04),
              //               // Image(image: AssetImage('assets/images/linkedin.png'), height: size.height * 0.04),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff787878)),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFFFCB117),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xADEFEFEF),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 5,
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
