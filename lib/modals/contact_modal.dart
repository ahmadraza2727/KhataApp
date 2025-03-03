import 'dart:io';

import 'package:app_1/components/audio_player.dart';
import 'package:app_1/components/dialogs.dart';
import 'package:app_1/services/audio/player.dart';
import 'package:app_1/services/audio/recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:app_1/components/type_aheads.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class CreateTransactionModal extends StatefulWidget {
  final void Function(Contact) onContactSelected;
  final Future<bool> Function(Map<String, dynamic>) onDoneModal;

  const CreateTransactionModal({
    super.key,
    required this.onContactSelected,
    required this.onDoneModal,
  });

  @override
  State<CreateTransactionModal> createState() => _CreateTransactionModalState();
}

class _CreateTransactionModalState extends State<CreateTransactionModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String _transactionType = "Received"; // Default value
  DateTime date = DateTime.now();
  DateTime? selectedDate;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String recordingPath = "";
  bool isRecording = false;
  int recordingDuration = 0;
  Timer? _timer;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Default date
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recorder.initRecorder();
  }

  @override
  void dispose() {
    print("disposing contact modal");
    if (recordingPath != "") {
      print("deleting the recording $recordingPath");
      File(recordingPath).deleteSync(); // Ensure deletion
    }
    _amountController.dispose();
    _reasonController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() async {
    if (recordingPath != "") {
      print("deleting recording for new recording $recordingPath");
      File f = File(recordingPath);
      f.deleteSync(); // Delete the file
      setState(() {
        recordingPath = "";
      });
    }
    bool success = await _recorder.startRecording();
    if (!success && mounted) {
      showErrorDialog(context, "Microhpone permission denied");
      return;
    }
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
    if (!mounted) {
      return;
    }
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

    if (!mounted) {
      return;
    }
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
    return PopScope(
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return; // If already popped, do nothing

        if (recordingPath != "") {
          print("deleting the recording $recordingPath");
          File(recordingPath).deleteSync(); // Ensure deletion
        }
        // Navigate to another screen instead of closing the app
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(home_route, (route) => false);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: FractionallySizedBox(
          heightFactor: 0.85, // Adjust height of modal
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Primarycolors.backgroundColor,
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
                        //INFO: due date
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                                padding: EdgeInsets.only(top: 4),
                                height: selectedDate == null ? 0 : 20,
                                child: Text(
                                  "Due Date",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate == null
                                        ? "Select Due Date"
                                        : "${selectedDate!.toLocal()}"
                                            .split(' ')[0],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(4),
                                    ),
                                    onPressed: () => _selectDate(context),
                                    child: Text("Pick a Date"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Recording Controls
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (isRecording)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Recording: ${recordingDuration}s",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: isRecording
                                      ? _stopRecording
                                      : _startRecording,
                                  icon: Icon(
                                      isRecording ? Icons.stop : Icons.mic,
                                      size: 24),
                                  label: Text(
                                    isRecording
                                        ? "Stop Recording"
                                        : "Start Recording",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isRecording ? Colors.red : Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                                if (recordingPath.isNotEmpty) ...[
                                  SizedBox(height: 30),
                                  ChangeNotifierProvider(
                                    create: (_) => AudioPlayerService(),
                                    child: AudioPlayerWidget(
                                      // recordingPath:
                                      // '/data/user/0/com.example.app_1/app_flutter/audio_1740843342986.aac',
                                      recordingPath: recordingPath,
                                    ),
                                  ),
                                ],
                              ],
                              // if (recordingPath.isNotEmpty) ...[
                              //   const SizedBox(height: 16),
                              //   ElevatedButton.icon(
                              //     onPressed: _playRecording,
                              //     icon:
                              //         const Icon(Icons.play_arrow, size: 24),
                              //     label: const Text(
                              //       "Play Recording",
                              //       style: TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: Colors.green,
                              //       foregroundColor: Colors.white,
                              //       padding: const EdgeInsets.symmetric(
                              //           vertical: 12, horizontal: 24),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10),
                              //       ),
                              //       elevation: 4,
                              //     ),
                              //   ),
                              // ],
                              // ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Sticky Submit Button at Bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _transactionType == "Gave"
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      bool success = await widget.onDoneModal({
                        "amount": _amountController.text,
                        "transactionType":
                            _transactionType == "Received" ? true : false,
                        "reason": _reasonController.text,
                        "recording": recordingPath,
                        "dueDate": selectedDate ?? DateTime.now(),
                        "context": context,
                      });
                      if (success) recordingPath = "";
                      setState(() {});
                      // widget.setPath(null);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save Transaction",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
        iconDisabledColor: _transactionType == "Gave"
            ? Colors.red.shade700
            : Colors.green.shade700,
        iconEnabledColor: _transactionType == "Gave"
            ? Colors.red.shade700
            : Colors.green.shade700,
      ),
    );
  }
}
