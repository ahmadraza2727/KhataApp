import 'dart:ui';

import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/person_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final userEmail = AuthServices.firebase().currentUser!.email;
  Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        final persons = provider.personsCache;
        return Scaffold(
          backgroundColor: Primarycolors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Persons",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Primarycolors.textDark,
              ),
            ),
            centerTitle: true,
          ),
          body: persons.isEmpty
              ? Center(
                  child: Text(
                    "No Contacts Found",
                    style: TextStyle(
                      color: Primarycolors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4),
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: ClipRRect(
                        // clipBehavior: Clip.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            title: Text(
                              person.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Primarycolors.textDark,
                              ),
                            ),
                            subtitle: Text(
                              person.phoneNumber,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Primarycolors.textDark, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PersonTransactionsScreen(
                                    contactId:
                                        int.tryParse(person.contactId) ?? 0,
                                    personName: person.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Primarycolors.redAccent,
          //   onPressed: () => _showContactsModal(context),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(100),
          //   ),
          //   child: Icon(Icons.add, color: Colors.white, size: 28),
          // ),
        );
      },
    );
  }

  void _showContactsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85, // Covers 85% of the screen
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Primarycolors.darkColor,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: Text(
                    "Contact List Goes Here",
                    style: TextStyle(
                      fontSize: 16,
                      color: Primarycolors.textDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primarycolors.darkColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
