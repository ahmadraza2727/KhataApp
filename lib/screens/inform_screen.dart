import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class InformScreen extends StatefulWidget {
  const InformScreen({super.key});

  @override
  State<InformScreen> createState() => _InformScreenState();
}

class _InformScreenState extends State<InformScreen> {
  final AuthServices _auth = AuthServices.firebase();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _auth.currentUser?.name ?? "";
  }

  Future<void> _updateDisplayName() async {
    try {
      await _auth.updateDisplayName(_nameController.text);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name updated successfully!")),
      );
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> _sendEmailVerification() async {
    try {
      await _auth.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification email sent!")),
      );
    } catch (e) {
      print("Error sending verification email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "User Information",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Primarycolors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text("Name",
                          style: TextStyle(
                              color: Primarycolors.textDark, fontSize: 16)),
                    ),
                    TextField(
                      controller: _nameController,
                      // decoration: InputDecoration(
                      //   filled: true,
                      //   fillColor: Primarycolors.primaryColor,
                      //   border: OutlineInputBorder(),
                      // ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _updateDisplayName,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Primarycolors.secondaryColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Update Name"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
            elevation: 2,
            color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email",
                        style: TextStyle(
                            color: Primarycolors.textDark, fontSize: 16)),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Primarycolors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(user?.email ?? "No Email",
                          style: TextStyle(color: Primarycolors.textDark)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            if (!(user?.isEmailVerified ?? false))
              ElevatedButton(
                onPressed: _sendEmailVerification,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Primarycolors.darkColor),
                child: Text("Verify Email"),
              ),
          ],
        ),
      ),
    );
  }
}
