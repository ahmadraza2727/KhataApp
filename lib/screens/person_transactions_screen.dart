import 'package:app_1/modals/modals.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/transaction_details.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/local_database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:iconic/iconic.dart';
import 'package:provider/provider.dart';
import 'package:app_1/constants/primary_colors.dart';

class PersonTransactionsScreen extends StatefulWidget {
  final int contactId;
  final String personName;
  final PersonDatabase selectedPerson;

  const PersonTransactionsScreen({
    Key? key,
    required this.contactId,
    required this.personName,
    required this.selectedPerson,
  }) : super(key: key);

  @override
  State<PersonTransactionsScreen> createState() =>
      _PersonTransactionsScreenState();
}

class _PersonTransactionsScreenState extends State<PersonTransactionsScreen> {
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
          final transactionMap = khataProvider.getTransactionsOfAPerson(
              contactId: widget.contactId);
          final transactions = transactionMap['transactions'];
          final ra = transactionMap['remaining'];
          final rca = transactionMap['received'];
          final ta = transactionMap['total'];
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
                padding: const EdgeInsets.all(20),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.personName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15), // Adds spacing between items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _amountInfo(
                          ra: ta,
                          icon: Iconic.bank,
                          title: "Total Ammount",
                          color: Primarycolors.textDark,
                        ),
                        _amountInfo(
                          ra: ra,
                          icon: Icons.arrow_upward,
                          title: "Remaining Amount",
                          color: Colors.red.shade700,
                        ),
                        _amountInfo(
                          ra: rca,
                          icon: Icons.arrow_downward,
                          title: "Received Amount",
                          color: Colors.green.shade700,
                        ),
                      ],
                    ),
                    SizedBox(height: 4), // Adds spacing between items
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailsScreen(
                              personName: transaction.person?.name ?? "Unknown",
                              amount: transaction.amount.toDouble(),
                              date: transaction.date,
                              reason: transaction.reason,
                              received: transaction.received,
                              phoneNumber: transaction.person?.phoneNumber ??
                                  "No-Number",
                              contactId: transaction.person!.contactId,
                              recording: transaction.recording,
                              person: transaction.person!,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Icon(
                          isReceived
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: isReceived ? Colors.green : Colors.redAccent,
                        ),
                        title: Wrap(
                          children: [
                            Text(
                              "Amount: Rs ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${transaction.amount}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isReceived
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        heroTag: "fabTransaction",
        onPressed: () => showTransactionModalForPerson(context, onDoneModal),
        backgroundColor: Primarycolors.darkColor,
        elevation: 8,
        child: Icon(Icons.add, size: 28, color: Primarycolors.primaryColor),
      ),
    );
  }

  Future<void> onDoneModal(Map<String, dynamic> map) async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    final owner = await provider.getCurrentUser();
    final reason = map['reason'] as String;
    final recording = map['recording'] as String;
    try {
      await provider.createTransaction(
          owner: owner,
          person: widget.selectedPerson,
          amount: int.tryParse(map['amount'].toString()) ?? 0, // ✅ Fix Here
          date: DateTime.now(), // ✅ Removed unnecessary cast
          dueDate: map["dueDate"],
          reason: reason,
          recording: recording,
          received: map['transactionType'] as bool);
    } on DatabasePersonamountGreaterThatTotalamountException catch (_) {
      // print("invalid amount recieved");
    } catch (e) {
      // print("there is an error: $e");
      rethrow;
    }
  }
}

class _amountInfo extends StatelessWidget {
  const _amountInfo({
    super.key,
    required this.ra,
    required this.icon,
    required this.title,
    required this.color,
  });

  final int ra;
  final dynamic icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 70,
      ),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(2, 4), // Shadow position
          ),
        ],
        // border: Border(
        //   left: BorderSide(color: Colors.black, width: 1), // Left border
        //   right: BorderSide(color: Colors.black, width: 1), // Right border
        //   bottom: BorderSide(color: Colors.black, width: 1), // Bottom border
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(
          //   title,
          //   style: TextStyle(
          //     fontSize: 10,
          //     fontWeight: FontWeight.w600,
          //     color: Primarycolors.textDark,
          //   ),
          // ),
          Icon(
            icon,
            color: color,
          ),
          Text(
            "Rs ${ra}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
