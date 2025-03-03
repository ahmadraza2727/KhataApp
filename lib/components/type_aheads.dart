import 'package:app_1/components/dialogs.dart';
import 'package:app_1/modals/modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTypeAhead extends StatefulWidget {
  final void Function(Contact) onContactSelected;
  // Contact? selectedContact;
  const ContactTypeAhead(
      // Contact selectedContact, {
      {
    super.key,
    required this.onContactSelected,
  });

  @override
  State<ContactTypeAhead> createState() => _ContactTypeAheadState();
}

class _ContactTypeAheadState extends State<ContactTypeAhead> {
  late Future<List<Contact>> _fetchedContacts;
  Contact? selectedContact;
  @override
  void initState() {
    _fetchedContacts = _fetchContacts(context);
    super.initState();
  }

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

  Future<void> _openCreateContact() async {
    showContactModal(context, onDoneModal);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: _fetchedContacts,
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
        return Column(
          children: [
            TypeAheadField<Contact>(
              hideOnUnfocus: false,
              suggestionsCallback: (search) {
                if (search.isEmpty) return contacts;

                final filteredContacts = contacts.where((contact) {
                  final name = contact.displayName.toString().toLowerCase();
                  final query = search.toLowerCase();
                  return name.contains(query);
                }).toList();

                return filteredContacts;
              },
              builder: (context, controller, focusNode) {
                return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact',
                    ));
              },
              itemBuilder: (context, contact) {
                return ListTile(
                  title: Text(contact.displayName.toString()),
                  subtitle: Text(contact.phones.first.number.toString()),
                );
              },
              emptyBuilder: (context) {
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _openCreateContact();
                        },
                        child: Text("Create Contact"),
                      ),
                    ),
                  ],
                );
              },
              onSelected: (contact) {
                selectedContact = contact;
                // print(selectedContact);
                widget.onContactSelected(contact);
                setState(() {});
              },
            ),
            if (selectedContact != null) ...[
              SizedBox(height: 20),
              Text('Selected Contact: ${selectedContact!.displayName}'),
              if (selectedContact!.phones.isNotEmpty ?? false)
                Text('Phone: ${selectedContact!.phones.first.number}'),
            ],
          ],
        ); // print(contacts);
      },
    );
  }

  Future<bool> onDoneModal() async {
    setState(() {
      _fetchedContacts = _fetchContacts(context); // Assigning a new future
    });
    return true;
  }
}
