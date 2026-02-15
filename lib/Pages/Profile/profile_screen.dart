import 'package:cab_taxi_app/Pages/Profile/Policies/about_us_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/Policies/privacy_policy_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/Policies/terms_conditions_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/booking_transactions_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/manage_drivers_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/manage_vehicle_screen.dart';
import 'package:cab_taxi_app/Pages/Profile/personal_information_screen.dart';
import 'package:cab_taxi_app/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/custom_app_bar.dart';
import '../Review/reviewSectionNew.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBAR(
        title: "",
        showLeading: false,
        showAction: false,
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// Top Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// Logout Button
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [

                          const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Red Circle Icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE04F5F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Help Button
                  GestureDetector(
                    onTap: () {
                      /// Navigate to Help Screen
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [

                          const Text(
                            "Help",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Headset with badge
                          Stack(
                            alignment: Alignment.center,
                            children: [

                              const Icon(
                                Icons.support_agent,
                                color: Color(0xFFE04F5F),
                                size: 24,
                              ),

                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE04F5F),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    "24",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [

                    /// Profile Image
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage(
                          'assets/images/profile_image.png'),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Nishu Tiwari",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "8448919650",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Rating
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AgentReviewScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            "4.9",
                            style: TextStyle(
                                fontWeight:
                                FontWeight.w600),
                          ),
                          const SizedBox(width: 5),

                          ...List.generate(
                            5,
                                (index) =>
                            const Icon(
                              Icons.star,
                              color:
                              Colors.amber,
                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 5),

                          const Text(
                            "(1 review)",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Account Section
                    _sectionTitle("Account"),

                    _profileTile(
                      context,
                      Icons.person,
                      "Personal Information",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PersonalInformationScreen(),
                          ),
                        );
                      },
                    ),

                    _profileTile(
                      context,
                      Icons.group,
                      "Manage Drivers",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ManageDriversScreen(),
                          ),
                        );
                      },
                    ),

                    _profileTile(
                      context,
                      Icons.directions_car,
                      "Manage Vehicles",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ManageVehicleScreen(),
                          ),
                        );
                      },
                    ),

                    _profileTile(
                      context,
                      Icons.credit_card,
                      "Payment Methods",
                    ),

                    _profileTile(
                      context,
                      Icons.receipt_long,
                      "Booking Transactions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const BookingTransactionsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Policies Section
                    _sectionTitle("Policies"),

                    _profileTile(
                      context,
                      Icons.info_outline,
                      "About Us",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AboutUsScreen(),
                          ),
                        );
                      },
                    ),

                    _profileTile(
                      context,
                      Icons.privacy_tip_outlined,
                      "Privacy Policy",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),

                    _profileTile(
                      context,
                      Icons.description_outlined,
                      "Term & Conditions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const TermsConditionsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Social Icons
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          backgroundColor:
                          Colors.red,
                          child: Icon(
                              Icons.play_arrow,
                              color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor:
                          Colors.pink,
                          child: Icon(
                              Icons.camera_alt,
                              color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor:
                          Colors.blue,
                          child: Icon(
                              Icons.facebook,
                              color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Logout Dialog
  void _showLogoutDialog(BuildContext context) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return CustomDialog(

          title: "Logout",

          content: "Are you sure you want to Logout?",

          leftButtonText: "Go back",

          rightButtonText: "Logout",

          onLeftPressed: () {
            Navigator.pop(context);
          },

          onRightPressed: () {

            Navigator.pop(context);

            /// logout logic here
          },
        );
      },
    );
  }

  /// Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10),
      child: Align(
        alignment:
        Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Profile Tile
  Widget _profileTile(
      BuildContext context,
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20),
      child: ListTile(
        contentPadding:
        EdgeInsets.zero,
        leading: Icon(
          icon,
          color:
          const Color(0xFFFCB117),
        ),
        title: Text(title),
        trailing:
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color:
          Color(0xFFFCB117),
        ),
        onTap: onTap,
      ),
    );
  }
}
