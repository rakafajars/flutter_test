import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7B1FA2),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected
              ? const Color(0xFFFF9800)
              : const Color(0xFFE1BEE7),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
