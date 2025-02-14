import 'package:app_1/components/type_aheads.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactModal extends StatefulWidget {
  final void Function(Contact) onContactSelected;
  const ContactModal({super.key, required this.onContactSelected});

  @override
  State<ContactModal> createState() => _ContactModalState();
}

class _ContactModalState extends State<ContactModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String _selectedTransaction = "Received"; // Default value
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Primarycolors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents overflow in modal
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // Submit Button
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
              onPressed: () {
                // Handle transaction logic
              },
              child: Text(
                "Save Transaction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Primarycolors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTransaction,
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
            _selectedTransaction = newValue!;
          });
        },
      ),
    );
  }
}
