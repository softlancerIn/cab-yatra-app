import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/network_service.dart';


class ReviewList extends StatefulWidget {
  final String profileName;
  final String profileEmail;
  final String profileImageUrl;

  const ReviewList({
    Key? key,
    required this.profileName,
    required this.profileEmail,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<dynamic> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviewList();
  }

  Future<void> fetchReviewList() async {
    try {
      final response = await NetworkService().getReviewList();
      if (response != null && response['status'] == true) {
        setState(() {
          reviews = response['data'];
          isLoading = false;
        });
      } else {
        print('Failed to load reviews or status false');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: width * 0.15,
                          foregroundImage:
                          widget.profileImageUrl.startsWith('http')
                              ? NetworkImage(widget.profileImageUrl)
                              : AssetImage(widget.profileImageUrl)
                          as ImageProvider,
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          widget.profileName,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.002),
                        Text(
                          widget.profileEmail,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.1),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (reviews.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.1),
                child: Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(width * 0.04),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ReviewCard(
                    name: '${review['rating_byName']}',
                    comment: review['text_review'] ?? '',
                    rating: int.tryParse(review['rating'] ?? '0') ?? 0,
                    imageUrl: 'assets/images/profile_sample.png',
                    date: '${review['created_at']}',
                    width: width,
                    height: height,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String comment;
  final String date;
  final int rating;
  final String imageUrl;
  final double width;
  final double height;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.comment,
    required this.date,
    required this.rating,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  String formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: height * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: width * 0.08,
                  backgroundImage: AssetImage(imageUrl),
                ),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            formatDate(date),
                            style: TextStyle(
                              fontSize: width * 0.03,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            Icons.star,
                            color: index < rating ? Colors.amber : Colors.grey,
                            size: width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.2),
              child: Text(
                comment,
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
