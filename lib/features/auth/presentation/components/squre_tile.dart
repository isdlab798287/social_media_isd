import 'package:flutter/material.dart';

class SqureTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const SqureTile({
    super.key,
    required this.imagePath,
    required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Image.asset(
          imagePath,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}