import 'package:exotic/controllers/src/ad_blocks/widgets/ad_block.dart';
import 'package:flutter/material.dart';

class AdTesting extends StatelessWidget {
  const AdTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ad Testing')),
      body: AdTestingComponent(),
    );
  }
}

class AdTestingComponent extends StatefulWidget {
  const AdTestingComponent({super.key});

  @override
  State<AdTestingComponent> createState() => _AdTestingComponentState();
}

class _AdTestingComponentState extends State<AdTestingComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdBlock(page: 'cart', position: 'middle'),
        AdBlock(page: 'cart', position: 'bottom'),
        AdBlock(page: 'category', position: 'top'),
        AdBlock(page: 'category', position: 'bottom'),
        AdBlock(page: 'product', position: 'top'),
        AdBlock(page: 'product', position: 'bottom'),
        AdBlock(page: 'search', position: 'top'),
        AdBlock(page: 'search', position: 'bottom'),
        AdBlock(page: 'cart', position: 'top'),
        AdBlock(page: 'cart', position: 'bottom'),
        AdBlock(page: 'checkout', position: 'top'),
        AdBlock(page: 'checkout', position: 'bottom'),
      ],
    );
  }
}
