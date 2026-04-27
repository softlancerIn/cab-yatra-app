import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Pages/Profile/model/review_model.dart';
import '../../Pages/Review/bloc/review_bloc.dart';
import '../../Pages/Review/bloc/review_event.dart';
import '../../Pages/Review/bloc/review_state.dart';
 import '../Custom_Widgets/custom_app_bar.dart';

class AgentReviewScreen extends StatefulWidget {
  final String? driverId;
  const AgentReviewScreen({super.key, this.driverId});

  @override
  State<AgentReviewScreen> createState() => _AgentReviewScreenState();
}

class _AgentReviewScreenState extends State<AgentReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviews(context, driverId: widget.driverId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBAR(
        title: "Profile & Reviews",
        showLeading: true,
        showAction: false,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          }

          final profile = state.profileModel?.data;
          final reviews = state.reviewModel?.data ?? [];
          final reviewDriver = state.reviewModel?.driver;

          // All data from API only
          final String driverName = reviewDriver?.name ?? profile?.name ?? 'Unknown';
          final String? driverImageUrl = reviewDriver?.driverImageUrl ?? profile?.driverImageUrl;
          final String ratingText = state.reviewModel?.averageRating?.toString() ?? profile?.rating ?? '0.0';
          final int totalReviewCount = state.reviewModel?.totalReviews ?? reviews.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Profile Image
                CircleAvatar(
                  radius: 45,
                  backgroundImage: (driverImageUrl != null && driverImageUrl.isNotEmpty)
                      ? NetworkImage(driverImageUrl)
                      : const AssetImage('assets/images/profile_image.png')
                          as ImageProvider,
                ),

                const SizedBox(height: 12),

                /// Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      ratingText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Based on $totalReviewCount rating\n& Reviews',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Agent Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            driverName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${profile?.type ?? 'Driver'})',
                            style: const TextStyle(
                              color: Color(0xFF787878),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text(
                            'Company name: ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            profile?.cInfo ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text(
                            'Booking Cancel Count: ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            profile?.cancelBooking?.toString() ?? '0',
                            style: const TextStyle(
                              color: Color(0xFFF45858),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Reviews Title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.50,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Reviews List
                if (reviews.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("No reviews found."),
                  )
                else
                  ListView.builder(
                    itemCount: reviews.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _reviewCard(reviews[index]);
                    },
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Review Card Widget
  Widget _reviewCard(ReviewData review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User Image
          CircleAvatar(
            radius: 28,
            backgroundImage: (review.ratingByImage != null &&
                    review.ratingByImage!.isNotEmpty)
                ? NetworkImage(review.ratingByImage!)
                : const AssetImage('assets/images/profile_image.png')
                    as ImageProvider,
          ),

          const SizedBox(width: 12),

          /// Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.ratingByName ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  review.ratingBy ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                /// Stars
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < (int.tryParse(review.rating ?? '0') ?? 0)
                          ? Colors.amber
                          : Colors.grey.shade300,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                if (review.checkBoxReview != null && review.checkBoxReview!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: review.checkBoxReview!.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3E4959),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ),

                Text(
                  review.textReview ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return "${_getMonth(date.month)} ${date.day}, ${date.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
