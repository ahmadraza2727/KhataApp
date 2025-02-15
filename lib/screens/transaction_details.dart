import 'dart:io';

import 'package:app_1/components/audio_player.dart';
import 'package:app_1/screens/person_transactions_screen.dart';
import 'package:app_1/services/audio/player.dart';
import 'package:flutter/material.dart';
import 'package:iconic/iconic.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_1/constants/primary_colors.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String personName;
  final String contactId;
  final double amount;
  final DateTime date;
  final String reason;
  final String recording;
  final String phoneNumber;
  final bool received;

  TransactionDetailsScreen({
    super.key,
    required this.personName,
    required this.amount,
    required this.date,
    required this.reason,
    required this.received,
    required this.phoneNumber,
    required this.contactId,
    required this.recording,
  });

  void _makeCall() async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
    print("Calling: $cleanedPhoneNumber");

    final Uri phoneUri = Uri.parse("tel:$cleanedPhoneNumber");

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Could not launch call");
    }
  }

  void _openWhatsApp() async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
    print("WhatsApping: $cleanedPhoneNumber");
    Uri whatsappUri = Uri.parse("https://wa.me/$cleanedPhoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      print("WhatsApp is not installed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      appBar: AppBar(
        title: const Text("Transaction Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Primarycolors.primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Primarycolors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Primarycolors.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Primarycolors.backgroundColor,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonTransactionsScreen(
                        contactId: int.tryParse(contactId) ?? 0,
                        personName: personName,
                      ),
                    ),
                  );
                },
                child: Text(
                  personName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Primarycolors.textDark,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const Divider(height: 20),

              /// **Transaction Type (Received/Sent)**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    received ? "Received" : "Sent",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: received
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  Icon(
                    received ? Icons.arrow_downward : Icons.arrow_upward,
                    color: received ? Colors.green : Colors.redAccent,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// **Amount**
              Text(
                "Rs ${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Primarycolors.textDark,
                ),
              ),
              const SizedBox(height: 8),

              /// **Date**
              Text(
                "Date: ${date.toLocal().toString().split(' ')[0]}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              /// **Reason**
              if (reason.isNotEmpty) ...[
                Text(
                  "Reason:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Primarycolors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              /// **Recording Player**
              if (recording != "No-Recording") ...[
                ChangeNotifierProvider(
                  create: (_) => AudioPlayerService(),
                  child: AudioPlayerWidget(recordingPath: recording),
                ),
              ],
            ],
          ),
        ),
      ),

      /// **Floating Buttons for Call & WhatsApp**
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _makeCall,
            heroTag: "callButton",
            backgroundColor: Colors.green,
            child: const Icon(Icons.call, color: Colors.white),
          ),
          FloatingActionButton(
            onPressed: _openWhatsApp,
            heroTag: "whatsappButton",
            backgroundColor: Colors.teal,
            child: const Icon(Icons.message, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
