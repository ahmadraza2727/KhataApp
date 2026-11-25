import 'package:app_1/screens/person_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/constants/primary_colors.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get database provider
    // final databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Due Dates",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Primarycolors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          final persons =
              provider.personsList; // Assuming provider has a list of persons

          if (persons.isEmpty) {
            return const Center(
              child: Text(
                "No due dates available.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person = persons[index];
              String formattedDate =
                  person.dueDate.toLocal().toString().split(' ')[0];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonTransactionsScreen(
                        contactId: int.tryParse(person.contactId) ?? 0,
                        personName: person.name,
                        selectedPerson: person,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      person.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text("Due Date: $formattedDate"),
                    trailing: Text(
                      "Remaining: ${person.remainingamount} PKR",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: person.remainingamount > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
