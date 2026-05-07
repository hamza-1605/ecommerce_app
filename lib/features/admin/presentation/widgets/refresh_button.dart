import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: BorderSide(width: 0.5, color: Colors.grey),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        minimumSize: Size(0, 0),
      ),
      onPressed: onTap,
      child: Icon(Icons.refresh, size: 20),
    );
  }
}