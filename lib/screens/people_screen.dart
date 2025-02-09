import 'package:app_1/screens/contact_picker.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showContactsModal(BuildContext context, KhataServices khataService) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
      child: ContactListScreen(
        khataService: khataService,
      ),
    ),
  );
}

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final userEmail = AuthServices.firebase().currentUser!.email;
  final _khataService = KhataServices();
  @override
  void initState() {
    _khataService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _khataService.getUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                body: StreamBuilder(
                    stream: _khataService.allPersons,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          print("Snapshot Data: ${snapshot.data}");
                          print("Has Data: ${snapshot.hasData}");
                          print("Snapshot Error: ${snapshot.error}");
                          if (snapshot.hasData) {
                            final itemCount = snapshot.data!.length;
                            final items = snapshot.data!;
                            return ListView.builder(
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(items[index].name),
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        default:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    }),
                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    showContactsModal(context, _khataService);
                  },
                  child: Icon(Icons.add),
                ),
              );

              break;

            default:
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}
