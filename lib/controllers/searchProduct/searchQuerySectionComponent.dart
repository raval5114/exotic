import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';

class Searchquerysectioncomponent extends StatefulWidget {
  final TextEditingController? controller;

  const Searchquerysectioncomponent({super.key, this.controller});

  @override
  State<Searchquerysectioncomponent> createState() =>
      _SearchquerysectioncomponentState();
}

class _SearchquerysectioncomponentState
    extends State<Searchquerysectioncomponent> {
  late TextEditingController controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = controller.text;

    /// 🔥 Debounce logic (VERY IMPORTANT)
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (text.isNotEmpty) {
        context.read<SearchProductBloc>().add(
          SearchProductSearchingEvent(query: text),
        );
      } else {
        context.read<SearchProductBloc>().add(SearchProductClearEvent());
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                )
                : null,
      ),
    );
  }
}
