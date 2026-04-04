import 'package:flutter/material.dart';

class SearchBarTesting extends StatefulWidget {
  const SearchBarTesting({super.key});

  @override
  State<SearchBarTesting> createState() => _SearchBarTestingState();
}

class _SearchBarTestingState extends State<SearchBarTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        title: const Text("Search Bar Testing"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [SearchFieldComponent()]),
      ),
    );
  }
}

class SearchFieldComponent extends StatelessWidget {
  const SearchFieldComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }
}
