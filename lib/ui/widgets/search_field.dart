// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Duration debounce;
  final bool autofocus;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.debounce = const Duration(milliseconds: 300),
    this.autofocus = true,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;

  Timer? debounce;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();

    super.dispose();
  }

  void onTextChanged(String text) {
    debounce?.cancel();
    debounce = Timer(widget.debounce, () => widget.onChanged(text));
  }

  void clearText() {
    debounce?.cancel();
    controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          final hasText = value.text.isNotEmpty;

          return TextField(
            controller: controller,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(16, 6, 16, 8),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: hasText
                  ? IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: clearText,
                    )
                  : Icon(Icons.search_rounded),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            onChanged: onTextChanged,
          );
        },
      ),
    );
  }
}
