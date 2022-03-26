import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

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
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffix: widget.query.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                  icon: Icon(
                    Icons.close,
                    color: primaryColor,
                  ),
                ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
