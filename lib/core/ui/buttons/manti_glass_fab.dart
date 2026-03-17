import 'package:flutter/material.dart';

class MantiGlassFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;

  const MantiGlassFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black87, size: 20),
              const SizedBox(width: 8),
              Text(
                label!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
