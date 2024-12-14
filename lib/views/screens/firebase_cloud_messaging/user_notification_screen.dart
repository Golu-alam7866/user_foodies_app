import 'package:flutter/material.dart';

class UserNotificationScreen extends StatelessWidget {
  const UserNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Screen"),),
      body: const Center(child: Text("User Notification Screen"),),
    );
  }
}
