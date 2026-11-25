import 'dart:io';
import 'package:app_1/components/audio_player.dart';
import 'package:app_1/components/dialogs.dart';
import 'package:app_1/screens/person_transactions_screen.dart';
import 'package:app_1/services/audio/player.dart';
import 'package:app_1/services/database/local_database_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_1/constants/primary_colors.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;
  final String personName;
  final String contactId;
  final double amount;
  final DateTime date;
  final String reason;
  final String recording;
  final String phoneNumber;
  final bool received;
  final PersonDatabase person;

  const TransactionDetailsScreen({
    super.key,
    required this.personName,
    required this.amount,
    required this.date,
    required this.reason,
    required this.received,
    required this.phoneNumber,
    required this.contactId,
    required this.recording,
    required this.person,
    required this.transactionId,
  });

  Future<bool> _makeCall() async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
    // print("Calling: $cleanedPhoneNumber");

    final Uri phoneUri = Uri.parse("tel:$cleanedPhoneNumber");

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      return true;
    } else {
      // print("Could not launch call");
      return false;
    }
  }

  Future<bool> _openWhatsApp() async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(' ', '');
    // print("WhatsApping: $cleanedPhoneNumber");
    Uri whatsappUri = Uri.parse("https://wa.me/$cleanedPhoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      // print("WhatsApp is not installed");

      return false;
    }
  }

  Future<bool> _shareAudioFile() async {
    if (recording != "") {
      final File audioFile = File(recording);

      if (await audioFile.exists()) {
        await Share.shareXFiles(
          [XFile(audioFile.path)],
          text: "Gave $amount to $personName ",
          subject: "The Date Was ${date.toString()}",
        );
        return true;
      } else {
        return false;
      }
    }
    return false;
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "transaction-$transactionId",
                  child: Material(
                    type: MaterialType.transparency,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonTransactionsScreen(
                              contactId: int.tryParse(contactId) ?? 0,
                              personName: personName,
                              selectedPerson: person,
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
                    // color: Primarycolors.textDark,
                    color:
                        received ? Colors.green.shade700 : Colors.red.shade700,
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
                if (recording != "") ...[
                  ChangeNotifierProvider(
                    create: (_) => AudioPlayerService(),
                    child: AudioPlayerWidget(
                      // recordingPath:
                      // '/data/user/0/com.example.app_1/app_flutter/audio_1740843342986.aac',
                      recordingPath: recording,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      /// **Floating Buttons for Call & WhatsApp**
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distribute
          children: [
            FloatingActionButton(
              onPressed: () async {
                bool success = await _makeCall();

                if (!success && context.mounted) {
                  showErrorDialog(context, "Error while sharing audio");
                }
              },
              heroTag: "callButton",
              backgroundColor: Colors.green,
              child: const Icon(Icons.call, color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: () async {
                bool success = await _openWhatsApp();
                if (!success && context.mounted) {
                  showErrorDialog(context, "Error while sharing audio");
                }
              },
              heroTag: "whatsappButton",
              backgroundColor: Colors.teal,
              child:
                  const Icon(Icons.message, color: Colors.white), // Fixed Icon
            ),
            if (recording != "")
              FloatingActionButton(
                onPressed: () async {
                  bool success = await _shareAudioFile();
                  if (!success && context.mounted) {
                    showErrorDialog(context, "Error while sharing audio");
                  }
                },
                heroTag: "shareButton",
                backgroundColor: Colors.teal,
                child: const Icon(Icons.share, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
