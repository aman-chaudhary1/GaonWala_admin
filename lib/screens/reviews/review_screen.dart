import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import '../dashboard/components/dash_board_header.dart';
import 'provider/review_provider.dart';
import 'package:intl/intl.dart';

class AdminReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: DashBoardHeader(),
          ),
          Gap(defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Reviews & Feedback",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => context.read<AdminReviewProvider>().fetchReviews(),
                ),
              ],
            ),
          ),
          Gap(defaultPadding),
          Expanded(
            child: Consumer<AdminReviewProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.reviews.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined, size: 64, color: Colors.white24),
                        Gap(10),
                        Text("No reviews found yet.", style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  itemCount: provider.reviews.length,
                  itemBuilder: (context, index) {
                    final review = provider.reviews[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: defaultPadding),
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  review.userId?.name ?? 'Unknown User',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              _buildRatingStars(review.rating ?? 0),
                            ],
                          ),
                          Gap(5),
                          Text(
                            review.userId?.email ?? '',
                            style: TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                          Gap(10),
                          Divider(color: Colors.white10),
                          Gap(10),
                          Text(
                            review.feedback ?? 'No feedback text provided.',
                            style: TextStyle(color: Colors.white70, height: 1.5),
                          ),
                          Gap(15),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              _formatDate(review.createdAt),
                              style: TextStyle(color: Colors.white24, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
