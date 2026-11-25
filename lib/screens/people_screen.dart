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
        final persons = provider.personsList;
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
                    return Hero(
                      tag: "person-${person.id.toString()}",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Card(
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
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: Duration(
                                          milliseconds:
                                              800), // Adjust duration as needed
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return PersonTransactionsScreen(
                                          contactId:
                                              int.tryParse(person.contactId) ??
                                                  0,
                                          personName: person.name,
                                          selectedPerson: person,
                                        );
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         PersonTransactionsScreen(
                                  //       contactId:
                                  //           int.tryParse(person.contactId) ?? 0,
                                  //       personName: person.name,
                                  //       selectedPerson: person,
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
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
}
