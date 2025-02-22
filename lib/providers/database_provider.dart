import 'dart:async';

import 'package:app_1/constants/predefined.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';

class DatabaseProvider with ChangeNotifier {
  DatabaseProvider({required this.nprovider});
  final NavigationProvider nprovider;
  String? _currrentEmail;
  //INFO : list of caches

  // persons to be accessed in all screens
  // person list may change on based on search of the user but person cache contains all persons in all cases
  List<PersonDatabase> personsList = [];
  //INFO : all persons that exist
  List<PersonDatabase> personsCache = [];
  //set used to discriminate persons who have transactions
  Set<PersonDatabase> personSet = {};

  // transactions to be accessed in all screens
  // transaction list may change on based on search of the user but transaction cache contains all transactions in all cases
  List<TransactionDatabase> transactionList = [];
  List<TransactionDatabase> transactionCache = [];

  //INFO: global database service
  static final KhataDatabaseServices _khataServices = KhataDatabaseServices();

  //INFO: main initialize function
  Future<void> initializeDatabase(String email) async {
    if (_currrentEmail != null && email == _currrentEmail) return;
    _currrentEmail = email;
    print("initialzing database");
    print("and email is $_currrentEmail");
    // INFO: initialize the database
    await _khataServices.getDatabase();
    //INFO: getting all the persons
    final persons = await _khataServices.getAllPersonsWithEmail(email);

    //INFO : get all transactions
    final allTransactions = await _khataServices.getAllTransactions(email);
    final usersTransactions = allTransactions.map((transaction) {
      final matchedPerson = persons.firstWhere(
        (person) => person.id == transaction.personId,
      );

      transaction.setPerson(matchedPerson);
      personSet.add(matchedPerson);
      return transaction;
    }).toList();
    transactionList = usersTransactions;
    transactionCache = usersTransactions;

    //INFO: get filtered persons

    // add the persons that hae transaction to the cache and list (initially the same)
    personsList = personSet.toList();
    personsCache = personSet.toList();
    // _personStreamController.add(personsCache);
    print("added persons to persons cache");
    notifyListeners();
  }

  void Search(String search) {
    print("searching $search");
    switch (nprovider.getCurrenScreenName()) {
      case screenNames.PEOPLE:
        {
          if (search.trim().isEmpty) {
            personsList = personsCache;
          } else {
            final per = personsCache.where((person) => person.name
                .toLowerCase()
                .contains(search.trim().toLowerCase()));
            personsList = per.toList();
          }
          notifyListeners(); // Moved outside the if-else block
        }
        break;
      case screenNames.TRANSACTIONS:
        {
          if (search.trim().isEmpty) {
            transactionList = transactionCache;
            notifyListeners(); // Moved outside the if-else block
          } else {
            final tra = transactionCache.where((transaction) => transaction
                .person!.name
                .toLowerCase()
                .contains(search.trim().toLowerCase()));
            transactionList = tra.toList();
          }
          notifyListeners(); // Moved outside the if-else block
        }
        break;
      default:
    }
  }

  Future<UserDatabase> getUser({required String email}) async {
    return await _khataServices.getUser(email: email);
  }

  Future<UserDatabase> getCurrentUser() async {
    return await _khataServices.getUser(email: _currrentEmail!);
  }

  Future<PersonDatabase> createPerson({
    required String contactId,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final person = await _khataServices.createPerson(
          contactId: contactId,
          email: _currrentEmail!,
          name: name,
          phoneNumber: phoneNumber);
      addPersonCache(person);
      return person;
    } on DatabasePersonAlreadyExistsException catch (_) {
      rethrow;
    }
  }

  Future<void> updatePerson(
      {required String contactId,
      required bool received,
      required int amount,
      DateTime? date}) async {
    final person = await _khataServices.updatePerson(
        contactId: contactId,
        email: _currrentEmail!,
        received: received,
        amount: amount);
    updatePersonCache(person);
  }

  Future<PersonDatabase> getPerson({
    required String contactId,
  }) async {
    final person = await _khataServices.getSinglePerson(
      contactId: contactId,
      email: _currrentEmail!,
    );
    updatePersonCache(person);
    return person;
  }

  // INFO : add a person to the global person cache
  void addPersonCache(PersonDatabase person) {
    print("adding to person cache");
    personsCache.add(person);
    personsList.add(person);
    notifyListeners();
  }

//INFO: update a person in the person cache
  void updatePersonCache(PersonDatabase person) {
    personsCache.removeWhere((person_) => person_.id == person.id);
    personsCache.add(person);
    personsList.removeWhere((person_) => person_.id == person.id);
    personsList.add(person);
    notifyListeners();
    print("updating the person cache");
  }

  Future<TransactionDatabase> createTransaction({
    required UserDatabase owner,
    required PersonDatabase person,
    required int amount,
    required DateTime date,
    required DateTime dueDate,
    required String reason,
    required String recording,
    required bool received,
    bool isSyncedWithCloud = false,
  }) async {
    final TransactionDatabase td = await _khataServices.createTransaction(
        owner: owner,
        person: person,
        amount: amount,
        date: date,
        dueDate: dueDate,
        reason: reason,
        recording: recording,
        received: received);
    addTransactionCache(td);
    return td;
  }

  Future<void> deleteTransaction({required int id}) async {
    await _khataServices.deleteTransaction(id: id);
    deleteTransactionCache(id);
  }

  Map<String, dynamic> getTransactionsOfAPerson({required int contactId}) {
    int ra = 0;
    int rca = 0;
    int ta = 0;
    final trs = transactionCache.where((transaction) {
      bool f = int.tryParse(transaction.person!.contactId) == contactId;
      if (f) {
        ra = transaction.person!.remainingamount;
        rca = transaction.person!.receivedAmount;
        ta = transaction.person!.totalamount;
      }
      return f;
    }).toList();
    return {"remaining": ra, "received": rca, "total": ta, "transactions": trs};
  }

  Future<TransactionDatabase> getTransaction({required int id}) =>
      _khataServices.getTransaction(id: id);

  // INFO : add a person to the global person cache
  void addTransactionCache(TransactionDatabase transaction) {
    print("adding transaction to transaction cache");
    transactionList.add(transaction);
    transactionCache.add(transaction);
    notifyListeners();
  }

//INFO: update a person in the person cache
  void deleteTransactionCache(int id) {
    print("updating transaction cache");
    transactionList.removeWhere((transaction_) => transaction_.id == id);
    transactionCache.removeWhere((transaction_) => transaction_.id == id);
    notifyListeners();
  }
}
