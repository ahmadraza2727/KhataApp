import 'package:app_1/components/dialogs.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/modals/modals.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/screens/transaction_details.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/local_database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);

    return FutureBuilder(
      future: provider.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Consumer<DatabaseProvider>(
          builder: (context, provider, child) {
            final transactions = provider.transactionList;

            return Scaffold(
              backgroundColor: Primarycolors.backgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Primarycolors.textDark,
                  ),
                ),
                centerTitle: true,
              ),
              body: transactions.isNotEmpty
                  ? ListView.builder(
                      // padding: const EdgeInsets.all(4),
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        final personName =
                            transaction.person?.name ?? "Unknown";
                        final amount = transaction.amount;
                        final date = transaction.date;

                        return Slidable(
                          key: ValueKey(transaction.id),
                          endActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  bool del = await showConfirmationDialog(
                                      context,
                                      "Delete Transaction",
                                      "Are you sure you want to delete this transaction permanentally");
                                  if (del) {
                                    provider.deleteTransaction(
                                        id: transaction.id);
                                  }
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                padding: EdgeInsets.all(4),
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: "transaction-${transaction.id}",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                                elevation: 3,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(6),
                                  leading: CircleAvatar(
                                    backgroundColor: transaction.received
                                        ? Colors.green
                                        : Colors.red,
                                    radius: 25,
                                    child: Icon(
                                      transaction.received
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    personName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: SingleChildScrollView(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Amount: Rs${amount.toString()}  ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600),
                                          ),
                                          Text(
                                            date
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // |  ${date.toLocal().toString().split(' ')[0]}",
                                  trailing: IconButton(
                                    icon: const Icon(Icons.info_outline,
                                        color: Colors.grey),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          transitionDuration: Duration(
                                              milliseconds:
                                                  800), // Adjust duration as needed
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return TransactionDetailsScreen(
                                              transactionId:
                                                  transaction.id.toString(),
                                              personName:
                                                  transaction.person?.name ??
                                                      "Unknown",
                                              amount:
                                                  transaction.amount.toDouble(),
                                              date: transaction.date,
                                              reason: transaction.reason,
                                              received: transaction.received,
                                              phoneNumber: transaction
                                                      .person?.phoneNumber ??
                                                  "No-Number",
                                              contactId:
                                                  transaction.person!.contactId,
                                              recording: transaction.recording,
                                              person: transaction.person!,
                                            ); // Replace with your destination screen
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                      //         TransactionDetailsScreen(
                                      //       transactionId:
                                      //           transaction.id.toString(),
                                      //       personName:
                                      //           transaction.person?.name ??
                                      //               "Unknown",
                                      //       amount: transaction.amount.toDouble(),
                                      //       date: transaction.date,
                                      //       reason: transaction.reason,
                                      //       received: transaction.received,
                                      //       phoneNumber:
                                      //           transaction.person?.phoneNumber ??
                                      //               "No-Number",
                                      //       contactId:
                                      //           transaction.person!.contactId,
                                      //       recording: transaction.recording,
                                      //       person: transaction.person!,
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
                    )
                  : const Center(
                      child: Text(
                        "No transactions found",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                heroTag: "fabTransaction",
                onPressed: () => showTransactionModal(
                    context, _onContactSelected, onDoneModal),
                backgroundColor: Primarycolors.primaryColor,
                elevation: 8,
                child:
                    Icon(Icons.add, size: 28, color: Primarycolors.darkColor),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> onDoneModal(Map<String, dynamic> map) async {
    // print("creating transaction");
    // print(map);
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    final owner = await provider.getUser();
    final reason = map['reason'] as String;
    final recording = map['recording'] as String;
    final childContext = map['context'] as BuildContext;
    // print(reason);
    // print(recording);
    // print(map["transactionType"]);
    final person = await provider.getPerson(contactId: (selectedContact!.id));
    try {
      await provider.createTransaction(
          owner: owner,
          person: person,
          amount: int.tryParse(map['amount'].toString()) ?? 0, // ✅ Fix Here
          date: DateTime.now(), // ✅ Removed unnecessary cast
          dueDate: map["dueDate"],
          reason: reason,
          recording: recording,
          received: map['transactionType'] as bool);
      return true;
    } on DatabasePersonamountGreaterThatTotalamountException catch (_) {
      if (!childContext.mounted) return false;
      showErrorDialog(childContext, "Received Amount Greater Than Sent Amount");
      // print("invalid amount recieved");
    } catch (e) {
      if (!childContext.mounted) return false;
      showErrorDialog(childContext, "Something Went Wrong");
      // print("there is an error: $e");
      // rethrow;
    }
    return false;
  }

  Future<PersonDatabase> _onContactSelected(Contact contact) async {
    selectedContact = contact;
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    try {
      return await provider.createPerson(
        contactId: contact.id,
        name: contact.displayName,
        phoneNumber: contact.phones.first.number,
      );
    } on DatabasePersonAlreadyExistsException catch (_) {
      return await provider.getPerson(
          contactId: contact
              .id); // Navigator.pop(context, contact); // Close modal on selection
      // } catch (e) {
      // rethrow;
    }
  }
}
