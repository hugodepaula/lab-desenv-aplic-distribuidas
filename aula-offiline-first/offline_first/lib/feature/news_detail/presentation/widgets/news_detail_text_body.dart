import 'package:flutter/material.dart';

class NewsDetailTextBody extends StatelessWidget {
  const NewsDetailTextBody({
    required this.content,
    super.key,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
