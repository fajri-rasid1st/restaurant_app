import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

class ReviewFormPage extends StatefulWidget {
  final String id;
  final String name;

  const ReviewFormPage({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _reviewController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _reviewController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
        ),
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        reverse: true,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Beri ulasan untuk: ${widget.name}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildReviewField(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: "Nama",
        hintText: "Masukkan nama anda",
      ),
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) return "Form harus diisi";

        return null;
      },
    );
  }

  TextFormField _buildReviewField() {
    return TextFormField(
      controller: _reviewController,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: "Ulasan",
        hintText: "Bagaimana tempat ini menurut Anda?",
        alignLabelWithHint: true,
      ),
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) return "Form harus diisi";

        return null;
      },
    );
  }

  SizedBox _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Consumer<RestaurantProvider>(
        builder: ((context, value, child) {
          return ElevatedButton(
            onPressed: () async {
              // Hilangkan fokus dari keybooard
              FocusScope.of(context).unfocus();

              if (_formKey.currentState!.validate()) {
                // Jika form telah diisi dengan benar, kirim data review ke server
                final isSuccess = await value.sendCustomerReview(
                  widget.id,
                  _nameController.text,
                  _reviewController.text,
                );

                if (isSuccess) {
                  Utilities.showSnackBarMessage(
                    context: context,
                    text: 'Berhasil menambah ulasan',
                  );
                } else {
                  Utilities.showSnackBarMessage(
                    context: context,
                    text: 'Gagal menambah ulasan. Periksa koneksi internet.',
                  );
                }

                // Kembali ke page sebelumnya
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Tambah Ulasan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }),
      ),
    );
  }
}