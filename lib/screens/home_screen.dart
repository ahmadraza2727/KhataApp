import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        // backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DatabaseProvider>(context, listen: false)
                  .initializeDatabase(
                      AuthServices.firebase().currentUser!.email);
            },
          ),
        ],
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          List<PersonDatabase> persons = provider.personsList;
          List<TransactionDatabase> transactions = provider.transactionList;

          // Calculate Summary Data
          int totalAmount =
              persons.fold(0, (sum, person) => sum + person.totalamount);
          int receivedAmount =
              persons.fold(0, (sum, person) => sum + person.receivedAmount);
          int remainingAmount =
              persons.fold(0, (sum, person) => sum + person.remainingamount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                _buildSummaryCard("Total Amount", totalAmount, Colors.blue),
                _buildSummaryCard(
                    "Received Amount", receivedAmount, Colors.green.shade700),
                _buildSummaryCard(
                    "Remaining Amount", remainingAmount, Colors.red.shade700),

                const SizedBox(height: 20),

                // Recent Transactions
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                _buildTransactionList(transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard(String title, int amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Primarycolors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "PKR $amount",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // Recent Transactions List Widget
  Widget _buildTransactionList(List<TransactionDatabase> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No transactions available."),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 5
          ? 5
          : transactions.length, // Show only latest 5 transactions
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
        color: Primarycolors.backgroundColor,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: transaction.received ? Colors.green : Colors.red,
              child: Icon(
                  transaction.received
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: Colors.white),
            ),
            title: Text("PKR ${transaction.amount}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                "${transaction.reason}\n${transaction.date.toLocal().toString().split(' ')[0]}"),
            trailing: Icon(Icons.receipt_long, color: Colors.grey[600]),
          ),
        );
      },
    );
  }
}
