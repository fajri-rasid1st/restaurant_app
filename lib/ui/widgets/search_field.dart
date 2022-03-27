import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          suffixIcon: const Icon(Icons.search_rounded),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
