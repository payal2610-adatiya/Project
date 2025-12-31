import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:artist_hub/core/constants/app_colors.dart';
import 'package:artist_hub/core/constants/app_strings.dart';
import 'package:artist_hub/models/booking_model.dart';
import 'package:artist_hub/providers/auth_provider.dart';
import 'package:artist_hub/providers/booking_provider.dart';
import 'package:artist_hub/customer/reviews/add_review_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Upcoming', 'Past', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadBookings() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      bookingProvider.fetchBookingsByCustomer(authProvider.currentUser!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppColors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(bookingProvider.bookings
              .where((booking) => booking.status == 'booked')
              .toList(),
            bookingProvider,
          ),
          _buildBookingList(bookingProvider.bookings
              .where((booking) => booking.status == 'completed')
              .toList(),
            bookingProvider,
          ),
          _buildBookingList(bookingProvider.bookings
              .where((booking) => booking.status == 'cancelled')
              .toList(),
            bookingProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings, BookingProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.artistName ?? 'Artist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status?.toUpperCase() ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM dd, yyyy').format(
                    DateTime.tryParse(booking.bookingDate ?? '') ?? DateTime.now(),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.grey, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.eventAddress ?? 'No address provided',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.payment, color: AppColors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Payment: ${booking.paymentStatus?.toUpperCase() ?? 'PENDING'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (booking.status == 'booked')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showCancelDialog(booking);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorColor,
                        side: BorderSide(color: AppColors.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to booking details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else if (booking.status == 'completed')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReviewScreen(booking: booking),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add Review'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'booked':
        return AppColors.successColor;
      case 'completed':
        return Color(0xFF2196F3);
      case 'cancelled':
        return AppColors.errorColor;
      default:
        return AppColors.grey;
    }
  }

  void _showCancelDialog(BookingModel booking) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to cancel this booking?'),
              const SizedBox(height: 16),
              Text(
                'Artist: ${booking.artistName ?? ''}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Date: ${DateFormat('MMMM dd, yyyy').format(
                  DateTime.tryParse(booking.bookingDate ?? '') ?? DateTime.now(),
                )}',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for cancellation',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (reasonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter cancellation reason'),
                      backgroundColor: AppColors.errorColor,
                    ),
                  );
                  return;
                }

                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

                final success = await bookingProvider.cancelBookingByCustomer(
                  bookingId: booking.id!,
                  customerId: authProvider.currentUser!.id!,
                  cancelReason: reasonController.text.trim(),
                );

                Navigator.pop(context);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancelled successfully'),
                      backgroundColor: AppColors.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }
}