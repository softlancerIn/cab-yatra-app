import 'package:cab_taxi_app/Pages/Profile/Policies/about_us_screen.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [

                /// 👤 Profile Section
                const SizedBox(height: 20),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage:
                      AssetImage('assets/images/profile_image.png'),
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

                    /// ⭐ Rating
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AgentReviewScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "4.9",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 5),
                          ...List.generate(
                            5,
                                (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
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
                  ],
                ),

                const SizedBox(height: 30),

                /// 🔹 Account Section
                _sectionTitle("Account"),
                _profileTile(context, Icons.person, "Personal Information"),
                _profileTile(context, Icons.group, "Manage Drivers"),
                _profileTile(context, Icons.directions_car, "Manage Vehicles"),
                _profileTile(context, Icons.credit_card, "Payment Methods"),
                _profileTile(context, Icons.receipt_long, "Booking Transactions"),

                const SizedBox(height: 20),

                /// 🔹 Policies Section
                _sectionTitle("Policies"),
                _profileTile(
                  context,
                  Icons.info_outline,
                  "About Us",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),
                _profileTile(context, Icons.privacy_tip_outlined, "Privacy Policy"),
                _profileTile(context, Icons.description_outlined, "Term & Conditions"),

                const SizedBox(height: 20),

                /// 🔹 Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.facebook, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Title Widget
  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Profile ListTile
  static Widget _profileTile(
      BuildContext context,
      IconData icon,
      String title,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: const Color(0xFFFCB117)),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFFFCB117),
        ),
        onTap: onTap,
      ),
    );
  }
}
