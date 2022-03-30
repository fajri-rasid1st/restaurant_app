import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  final String query;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchField({
    Key? key,
    required this.query,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          border: InputBorder.none,
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: _controller.text.isEmpty
              ? const Icon(Icons.search_rounded)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
        ),
        style: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
