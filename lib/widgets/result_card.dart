import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String result;
  final bool isDark;
  const ResultCard({super.key, required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: result.isNotEmpty ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SelectableText(
          result,
          style: const TextStyle(fontSize: 18),
          minLines: 6,
          maxLines: 6,
        ),
      ),
    );
  }
}
