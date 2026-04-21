import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Productviewertesting extends StatelessWidget {
  const Productviewertesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing Product Viewer"), centerTitle: true),
      body: Column(children: [ProductViewerTestingComponent()]),
    );
  }
}

class ProductViewerTestingComponent extends StatefulWidget {
  const ProductViewerTestingComponent({super.key});

  @override
  State<ProductViewerTestingComponent> createState() =>
      _ProductViewerTestingComponentState();
}

class _ProductViewerTestingComponentState
    extends State<ProductViewerTestingComponent> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: "Product URL",
              hintText: "Enter the product URL",
              prefixIcon: const Icon(Icons.link_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Product Title",
              hintText: "Enter the product title",
              prefixIcon: const Icon(Icons.title_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_urlController.text.isNotEmpty &&
                    _titleController.text.isNotEmpty) {
                  context.push(
                    '/ProductsViewer',
                    extra: {
                      'url': _urlController.text,
                      'title': _titleController.text,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both URL and Title'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text(
                "Redirect to Product Viewer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
