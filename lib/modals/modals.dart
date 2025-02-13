import 'package:app_1/modals/contact_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void showContactsModal(
  BuildContext context,
  void Function(Contact) _onContactSelected,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) => Builder(
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ContactListScreen(
          onContactSelected: _onContactSelected,
        ),
      ),
    ),
  );
}
