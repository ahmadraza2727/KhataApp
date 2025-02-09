import 'package:app_1/components/dialogs.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListScreen extends StatelessWidget {
  final KhataServices khataService;
  const ContactListScreen({super.key, required this.khataService});

  Future<List<Contact>> _fetchContacts(BuildContext context) async {
    if (await Permission.contacts.request().isGranted) {
      try {
        return await FlutterContacts.getContacts(withProperties: true);
      } catch (e) {
        _showErrorDialog(context, "Failed to load contacts");
        return [];
      }
    } else {
      _showErrorDialog(context, "Permission denied");
      return [];
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: _fetchContacts(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(child: Text('No contacts found'));
        }

        List<Contact> contacts = snapshot.data!;
        print(contacts);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(contact.displayName ?? 'No Name'),
              subtitle: Text(contact.phones.isNotEmpty
                  ? contact.phones.first.number
                  : 'No Phone'),
              onTap: () => _onContactSelected(context, contact),
            );
          },
        );
      },
    );
  }

  void _onContactSelected(BuildContext context, Contact contact) async {
    try {
      await khataService.createPerson(
        contactId: contact.id,
        name: contact.displayName,
        phoneNumber: contact.phones.first.number,
      );
      Navigator.pop(context, contact); // Close modal on selection
    } on DatabasePersonAlreadyExistsException catch (_) {
      print("person exists");
      Navigator.pop(context, contact); // Close modal on selection
      showErrorDialog(context, "person already exists");
    }
  }
}
