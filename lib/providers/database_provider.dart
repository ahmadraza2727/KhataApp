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
  List<PersonDatabase> personsList = [];
  List<PersonDatabase> personsCache = [];
  Set<PersonDatabase> personSet = {};
  // final StreamController<List<PersonDatabase>> _personStreamController =
  //     StreamController<List<PersonDatabase>>.broadcast();
  //
  // Stream<List<PersonDatabase>> get personStream =>
  //     _personStreamController.stream;

  List<UserDatabase> userCache = [];

  List<TransactionDatabase> transactionList = [];
  List<TransactionDatabase> transactionCache = [];

  //INFO: global database service
  static final KhataDatabaseServices _khataServices = KhataDatabaseServices();

  //INFO: constructor
  // DatabaseProvider(String email) {
  //   initializeDatabase(email);
  // }
  //INFO: main initialize function
  Future<void> initializeDatabase(String email) async {
    if (_currrentEmail != null && email == _currrentEmail) return;
    _currrentEmail = email;
    print("initialzing database");
    print("and email is $_currrentEmail");
    // INFO: initialize the database
    await _khataServices.getDatabase();
    //INFO: getting all the persons
    final persons = await _khataServices.getAllPerson(email);
    //TODO: getting all the users

    //INFO : get all transactions
    final t = await _khataServices.getAllTransactions(email);
    final transactions = t.map((transaction) {
      final matchedPerson = persons.firstWhere(
        (person) => person.id == transaction.personId,
      );

      transaction.setPerson(matchedPerson);
      personSet.add(matchedPerson);
      return transaction; // ✅ Return transaction
    }).toList();
    transactionList = transactions;
    transactionCache = transactions;

    //INFO: get filtered persons

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
    final person = await _khataServices.getPerson(
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
