import 'package:cab_taxi_app/Pages/Chat/chat_details_screen.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  bool isPostedSelected = true;

  final List<Map<String, String>> chatList = [
    {
      "name": "Viney Sethi",
      "message": "Driver name: Mukesh",
      "time": "Just now",
      "bookingId": "254355"
    },
    {
      "name": "Viney Sethi",
      "message": "Mujhe Booking Dedo",
      "time": "34 Min",
      "bookingId": "254356"
    },
    {
      "name": "Viney Sethi",
      "message": "Hhi hlloooo",
      "time": "1 hour ago",
      "bookingId": "254355"
    },
    {
      "name": "Viney Sethi",
      "message": "Hello",
      "time": "23 hour ago",
      "bookingId": "254355"
    },
    {
      "name": "Viney Sethi",
      "message": "Driver name: Mukesh",
      "time": "Yesterday",
      "bookingId": "254355"
    },
    {
      "name": "Viney Sethi",
      "message": "Driver name: Mukesh",
      "time": "4 days ago",
      "bookingId": "254355"
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          /// Toggle
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [

                /// Posted
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isPostedSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isPostedSelected
                            ? const Color(0xFFF4A100)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "posted",
                          style: TextStyle(
                            color: isPostedSelected
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Received
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isPostedSelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isPostedSelected
                            ? const Color(0xFFF4A100)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "Received",
                          style: TextStyle(
                            color: !isPostedSelected
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {

                final chat = chatList[index];

                return Column(
                  children: [

                    ListTile(

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsScreen(
                              name: chat["name"] ?? "",
                              bookingId: chat["bookingId"] ?? "",
                            ),
                          ),
                        );
                      },

                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                            "assets/images/profile_image.png"),
                      ),

                      title: Text(chat["name"] ?? ""),

                      subtitle: Text(chat["message"] ?? ""),

                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Booking ID : ${chat["bookingId"] ?? ""}"),
                          Text(chat["time"] ?? ""),
                        ],
                      ),
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
