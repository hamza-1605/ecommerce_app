import 'dart:io';

import 'package:flutter/material.dart';

class NewImagesPreview extends StatelessWidget {
  const NewImagesPreview({super.key, required this.onTap, required this.newImages});
  final Function onTap;
  final List<File> newImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          'New Images',
          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newImages.length,
            itemBuilder: (_, i) => Stack(
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(newImages[i], fit: BoxFit.cover),
                  ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ]
    );
  }
}