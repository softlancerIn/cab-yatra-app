import 'package:flutter/material.dart';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';

class ReviewPage extends StatefulWidget {
  final int? driverId;
  final String? bookingId;

  const ReviewPage({super.key, this.driverId, this.bookingId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedStars = 0;
  final List<bool> _checkBoxValues = [false, false, false, false];
  final TextEditingController _reviewController = TextEditingController();
  final String _driverName = '';
  Color _getStarColor(int index) {
    if (_selectedStars >= index) {
      switch (index) {
        case 1:
          return const Color(0xFFFF0000);
        case 2:
          return const Color(0xFFFF7A00);
        case 3:
          return const Color(0xFFFFC700);
        case 4:
          return const Color(0xFF7FFF00);
        case 5:
          return const Color(0xFF00FF00);
      }
    }
    return Colors.grey;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppBAR(title: "Write Review"),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/profile_sample.png'),
                          // child: Text(
                          //   'N/A',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Text(
                          // widget.driverId.toString(),
                          _driverName.isNotEmpty ? _driverName : 'Loading...',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedStars = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: _getStarColor(index + 1),
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: [
                      CheckboxListTile(
                        value: _checkBoxValues[0],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkBoxValues[0] = value!;
                          });
                        },
                        title: const Text(
                          'Neat & clean Cab.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _checkBoxValues[1],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkBoxValues[1] = value!;
                          });
                        },
                        title: const Text(
                          'Good Behavior.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _checkBoxValues[2],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkBoxValues[2] = value!;
                          });
                        },
                        title: const Text(
                          'On Time.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _checkBoxValues[3],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkBoxValues[3] = value!;
                          });
                        },
                        title: const Text(
                          'Good Music System.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write Review',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFB900),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Center(
                          child: Text(
                            'Submit Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
}
