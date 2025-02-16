import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/transaction_details.dart';
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
          "Personal Transactions",
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
          final transactionMap =
              khataProvider.getTransactionsOfAPerson(contactId: contactId);
          final transactions = transactionMap['transactions'];
          final am = transactionMap['amount'];
          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                "No transactions found!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10), // Adds spacing between items
                    Row(
                      children: [
                        Text(
                          "Total Amount : Rs ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Primarycolors.textDark,
                          ),
                        ),
                        Text(
                          "${am.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isReceived = transaction.received;

                    return GestureDetector(
                    onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionDetailsScreen(
                                          personName:
                                              transaction.person?.name ??
                                                  "Unknown",
                                          amount: transaction.amount.toDouble(),
                                          date: transaction.date,
                                          reason: transaction.reason,
                                          received: transaction.received,
                                          phoneNumber:
                                              transaction.person?.phoneNumber ??
                                                  "No-Number",
                                          contactId:
                                              transaction.person!.contactId,
                                          recording: transaction.recording,
                                        ),
                                      ),
                                    );
                                  },
                      child: ListTile(
                        leading: Icon(
                          isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isReceived ? Colors.green : Colors.redAccent,
                        ),
                        title: Text(
                          "Amount: Rs ${transaction.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                            color: isReceived
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
