import 'package:app_1/components/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListScreen extends StatefulWidget {
  final void Function(Contact) onContactSelected;
  const ContactListScreen({super.key, required this.onContactSelected});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Future<List<Contact>> _fetchContacts(BuildContext context) async {
    if (await Permission.contacts.request().isGranted) {
      try {
        return await FlutterContacts.getContacts(withProperties: true);
      } catch (e) {
        showErrorDialog(context, "Failed to load contacts");
        return [];
      }
    } else {
      showErrorDialog(context, "Permission denied");
      return [];
    }
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
        // print(contacts);
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
              onTap: () => widget.onContactSelected(contact),
            );
          },
        );
      },
    );
  }
}
