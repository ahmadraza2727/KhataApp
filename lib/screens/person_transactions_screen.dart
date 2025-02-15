import 'package:app_1/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_1/constants/primary_colors.dart';

class PersonTransactionsScreen extends StatelessWidget {
  final int contactId;
  final String personName;

  const PersonTransactionsScreen({
    Key? key,
    required this.contactId,
    required this.personName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "$personName's Transactions",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Primarycolors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Primarycolors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, khataProvider, child) {
          final transactions =
              khataProvider.getTransactionsOfAPerson(contactId: contactId);

          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                "No transactions found!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isReceived = transaction.received;

              return ListTile(
                leading: Icon(
                  isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isReceived ? Colors.green : Colors.redAccent,
                ),
                title: Text(
                  "Amount: \$${transaction.amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Date: ${transaction.date.toLocal().toString().split(' ')[0]} \nReason: ${transaction.reason}",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                trailing: Text(
                  isReceived ? "Received" : "Sent",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isReceived ? Colors.green.shade700 : Colors.red.shade700,
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
