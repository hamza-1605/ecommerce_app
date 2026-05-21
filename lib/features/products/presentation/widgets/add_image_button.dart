import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Color.fromARGB(255, 116, 116, 116),
            ),
            SizedBox(height: 6),
            Text(
              'Tap to add images',
              style: TextStyle(
                color: Color.fromARGB(255, 116, 116, 116),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}