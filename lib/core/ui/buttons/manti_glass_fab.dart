import 'package:flutter/material.dart';

class MantiGlassFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MantiGlassFab({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 62,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.black87,
        iconSize: 24,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
