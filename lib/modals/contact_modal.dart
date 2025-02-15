import 'dart:io';

import 'package:app_1/services/audio/recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:app_1/components/type_aheads.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class ContactModal extends StatefulWidget {
  final void Function(Contact) onContactSelected;
  final Future<void> Function(Map<String, dynamic>) onDoneModal;

  const ContactModal({
    super.key,
    required this.onContactSelected,
    required this.onDoneModal,
  });

  @override
  State<ContactModal> createState() => _ContactModalState();
}

class _ContactModalState extends State<ContactModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String _transactionType = "Received"; // Default value
  DateTime date = DateTime.now();

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String recordingPath = "";
  bool isRecording = false;
  int recordingDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _recorder.initRecorder();
  }

  @override
  void dispose() {
    // if (recordingPath != null) {
    //   File(recordingPath!).deleteSync(); // Ensure deletion
    // }
    _amountController.dispose();
    _reasonController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() async {
    // if (recordingPath != null) {
    //   File f = File(recordingPath!);
    //   f.deleteSync(); // Delete the file
    //   setState(() {
    //     recordingPath = null;
    //   });
    // }
    await _recorder.startRecording();
    setState(() {
      isRecording = true;
      recordingDuration = 0;
    });

    // Start Timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        recordingDuration++;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Recording started..."),
          duration: Duration(seconds: 1)),
    );
  }

  void _stopRecording() async {
    await _recorder.stopRecording();
    _timer?.cancel();

    if (_recorder.filePath != null) {
      recordingPath = _recorder.filePath!;
    }

    setState(() {
      isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Recording saved!"), duration: Duration(seconds: 1)),
    );
  }

  void _playRecording() async {
    if (recordingPath != "") {
      await _audioPlayer.play(DeviceFileSource(recordingPath));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No recording available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: FractionallySizedBox(
        heightFactor: 0.85, // Adjust height of modal
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Primarycolors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Title
              Center(
                child: Text(
                  "Make A Transaction",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Primarycolors.textDark,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Picker
                      ContactTypeAhead(
                        onContactSelected: widget.onContactSelected,
                      ),
                      SizedBox(height: 16),

                      // Amount Input
                      _buildInputField(
                        controller: _amountController,
                        label: "Amount",
                        prefixText: "Rs ",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),

                      // Transaction Type Dropdown
                      _buildDropdown(),
                      SizedBox(height: 16),

                      // Expandable Reason TextField
                      _buildInputField(
                        controller: _reasonController,
                        label: "Reason",
                        maxLines: null, // Expands when needed
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 16),

                      // Recording Controls
                      Center(
                        child: Column(
                          children: [
                            if (isRecording)
                              Text(
                                "Recording: ${recordingDuration}s",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: isRecording
                                  ? _stopRecording
                                  : _startRecording,
                              icon: Icon(isRecording ? Icons.stop : Icons.mic),
                              label: Text(isRecording
                                  ? "Stop Recording"
                                  : "Start Recording"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isRecording ? Colors.red : Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (recordingPath != "") ...[
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _playRecording,
                                icon: Icon(Icons.play_arrow),
                                label: Text("Play Recording"),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Submit Button at Bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primarycolors.darkColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    print("savinf transaction");
                    print("recording path is $recordingPath");
                    await widget.onDoneModal({
                      "amount": _amountController.text,
                      "transactionType":
                          _transactionType == "Received" ? true : false,
                      "reason": _reasonController.text,
                      "recording": recordingPath,
                    });
                    // widget.setPath(null);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField with Styling
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? prefixText,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        filled: true,
        fillColor: Primarycolors.primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Custom Dropdown Widget
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Primarycolors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _transactionType,
        decoration: InputDecoration(
          labelText: "Transaction Type",
          border: InputBorder.none,
        ),
        items: ["Received", "Gave"]
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _transactionType = newValue!;
          });
        },
      ),
    );
  }
}
