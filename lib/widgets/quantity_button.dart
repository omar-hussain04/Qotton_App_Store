import 'package:flutter/material.dart';

/// A reusable +/- quantity button used in Cart and Product Details screens.
class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 8.0,
    this.iconSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(size),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
