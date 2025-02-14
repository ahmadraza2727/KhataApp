import 'package:app_1/components/dialogs.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/modals/modals.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

// void showContactsModal(
//     BuildContext context, KhataDatabaseServices khataService) {
//   final provider = Provider.of<DatabaseProvider>(context,
//       listen: false); // ✅ Get the existing provider
//
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     backgroundColor: Colors.white,
//     isScrollControlled: true,
//     builder: (context) => ChangeNotifierProvider<DatabaseProvider>.value(
//       value: provider, // ✅ Pass the existing provider
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.6,
//         child: ContactListScreen(),
//       ),
//     ),
//   );
// }

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final userEmail = AuthServices.firebase().currentUser!.email;
  // final _khataService = KhataDatabaseServices();
  // bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // _khataService.close();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<DatabaseProvider>(context, listen: false);
    final email = AuthServices.firebase().currentUser!.email;

    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        final persons = provider.personsCache;
        return Scaffold(
          backgroundColor: Primarycolors.backgroundColor,
          body: ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person = persons[index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text(person.phoneNumber),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showContactsModal(context, _onContactSelected),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _onContactSelected(Contact contact) async {
    final provider = Provider.of<DatabaseProvider>(
      context,
      listen: false,
    );
    // final user = await provider.getUser(
    // email: AuthServices.firebase().currentUser!.email);
    // final provider = context.read<DatabaseProvider>();
    // print("on selected contact");
    final email = AuthServices.firebase().currentUser!.email;
    try {
      await provider.createPerson(
        contactId: contact.id,
        email: email,
        name: contact.displayName,
        phoneNumber: contact.phones.first.number,
      );
      Navigator.pop(context, contact); // Close modal on selection
    } on DatabasePersonAlreadyExistsException catch (_) {
      // print("person exists");
      Navigator.pop(context, contact); // Close modal on selection
      showErrorDialog(context, "person already exists");
    } catch (e) {
      // print("there is an error");
      rethrow;
    }
  }
}
