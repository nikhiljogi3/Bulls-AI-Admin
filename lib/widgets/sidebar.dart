import 'package:flutter/material.dart';

// Legacy sidebar widget kept for compatibility
// The actual sidebar is now implemented in admin_layout.dart
class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
