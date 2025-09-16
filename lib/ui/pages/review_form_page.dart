// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/providers/service_providers/customer_review_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurant_detail_provider.dart';

class ReviewFormPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReviewFormPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController reviewController;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    reviewController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beri tanggapan Anda tentang ${widget.restaurantName}.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16),
              buildNameTextField(),
              SizedBox(height: 16),
              buildReviewTextField(),
              SizedBox(height: 16),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget function untuk membuat textfield nama
  Widget buildNameTextField() {
    return TextFormField(
      controller: nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Nama',
        hintText: 'Masukkan nama Anda',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) return 'Nama harus diisi';

        return null;
      },
    );
  }

  /// Widget function untuk membuat textfield review
  Widget buildReviewTextField() {
    return TextFormField(
      controller: reviewController,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Ulasan',
        hintText: 'Bagaimana restaurant ini menurut Anda?',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) return 'Ulasan harus diisi';

        return null;
      },
    );
  }

  /// Widget function untuk membuat button submit
  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        label: Text(
          'Tambah Ulasan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(Icons.add_rounded),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: submitReview,
      ),
    );
  }

  /// Function untuk mengirim data review ke server
  Future<void> submitReview() async {
    // Hilangkan fokus dari keybooard
    FocusScope.of(context).unfocus();

    // Jika form telah diisi dengan benar, kirim data review ke server.
    if (formKey.currentState!.validate()) {
      final customerReviewProvider = context.read<CustomerReviewProvider>();

      await customerReviewProvider.sendCustomerReview(
        id: widget.restaurantId,
        name: nameController.text,
        review: reviewController.text,
      );

      if (!mounted) return;

      final message = customerReviewProvider.message;
      final customerReviews = customerReviewProvider.customerReviews;

      // Tampilkan snackbar
      Utilities.showSnackBarMessage(
        context: context,
        text: message,
      );

      final restaurantDetailProvider = context.read<RestaurantDetailProvider>();

      if (restaurantDetailProvider.restaurantDetail != null) {
        final newRestaurantDetail = restaurantDetailProvider.restaurantDetail!.copyWith(
          customerReviews: customerReviews,
        );

        restaurantDetailProvider.restaurantDetail = newRestaurantDetail;
      }

      // Kembali ke page sebelumnya
      Navigator.pop(context);
    }
  }
}
