import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatelessWidget {

  final String name;
  final String bookingId;

  const ChatDetailsScreen({
    super.key,
    required this.name,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.call, color: Colors.orange),
          )
        ],
      ),

      body: Column(
        children: [

          /// Booking Card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "ID : $bookingId (open)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Jan 12, 2026 @ 5:00AM      One Way Trip",
                  style: TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 10),

                const Row(
                  children: [

                    Icon(Icons.circle, size: 10, color: Colors.orange),

                    SizedBox(width: 8),

                    Expanded(
                      child: Text("Sector- 63, Noida"),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                const Row(
                  children: [

                    Icon(Icons.circle, size: 10, color: Colors.red),

                    SizedBox(width: 8),

                    Expanded(
                      child: Text("Nainital, Uttarakhand"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Image.asset(
                      "assets/images/profile_image.png",
                      width: 60,
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Text(
                        "Dzire, Etios, Aura, Glanza Similar (a/c)",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "₹1,000\nCommission",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (){},
                    child: const Text(
                      "Send Commission request",
                    ),
                  ),
                )
              ],
            ),
          ),

          /// Messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [

                _leftMessage("Click to see Vehicle and Car Photo"),

                _leftMessage(
                    "Driver Name: Mukesh Kushwaha\nContact Number: 8770967506\nVehicle Registration : UP14HT9864\nVehicle Type: Ertiga"),

                _leftMessage("Bhiya 500 Ka Payment Link Bhaj Do"),

                _rightMessage("Ok Bhaj Raha Hun"),

                _centerMessage(
                    "You have initiated payment for commission of ₹700.0 in advance to assign this booking"),

                _leftMessage("Thankyou mai payment karta hun"),
              ],
            ),
          ),

          /// Input
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Say Something...",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _leftMessage(String text){
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 60),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _rightMessage(String text){
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 60),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }

  Widget _centerMessage(String text){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
