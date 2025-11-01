import 'dart:io';
import 'package:flutter/material.dart';
import 'user_data.dart'; // ✅ import this

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF063851),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundImage: UserData.imagePath.isNotEmpty
                      ? (UserData.imagePath.startsWith('assets/')
                          ? AssetImage(UserData.imagePath)
                          : FileImage(File(UserData.imagePath))) as ImageProvider
                      : const AssetImage('assets/default_profile.png'),
                ),
                const SizedBox(height: 40),

                // Username
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User name :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    UserData.username.isNotEmpty
                        ? UserData.username
                        : "Sample User",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User email :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    UserData.email.isNotEmpty
                        ? UserData.email
                        : "sample@email.com",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // App version
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "App version",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Diary version 1.1. (beta)",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Logout Button
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "log out",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
