import 'package:flutter/material.dart';

class SomeButtonPreview extends StatelessWidget {
  const SomeButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('Click me'),
      ),
    );
  }
}
