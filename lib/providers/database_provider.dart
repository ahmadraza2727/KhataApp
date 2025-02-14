import 'dart:async';

import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';

class DatabaseProvider with ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  //INFO : list of caches
  List<PersonDatabase> personsCache = [];
  // final StreamController<List<PersonDatabase>> _personStreamController =
  //     StreamController<List<PersonDatabase>>.broadcast();
  //
  // Stream<List<PersonDatabase>> get personStream =>
  //     _personStreamController.stream;

  List<UserDatabase> userCache = [];
  List<TransactionDatabase> transactionCache = [];

  //INFO: global database service
  static final KhataDatabaseServices _khataServices = KhataDatabaseServices();

  //INFO: constructor
  DatabaseProvider(String email) {
    initializeDatabase(email);
  }
  //INFO: main initialize function
  Future<void> initializeDatabase(String email) async {
    print("initialzing database");
    // INFO: initialize the database
    await _khataServices.getDatabase();
    //INFO: getting all the persons
    final persons = await _khataServices.getAllPerson(email);
    personsCache = persons.toList();
    // _personStreamController.add(personsCache);
    print("added persons to persons cache");
    //TODO: getting all the users

    //INFO : get all transactions
    final transactions = await _khataServices.getAllTransactions();
    transactionCache = transactions.toList();
    _isInitialized = true;
    notifyListeners();
  }

  Future<UserDatabase> getUser({required String email}) async {
    return await _khataServices.getUser(email: email);
  }

  Future<void> createPerson({
    required String contactId,
    required String email,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final person = await _khataServices.createPerson(
          contactId: contactId,
          email: email,
          name: name,
          phoneNumber: phoneNumber);
      addPersonCache(person);
    } on DatabasePersonAlreadyExistsException catch (_) {
      rethrow;
    }
  }

  Future<void> updatePerson(
      {required String contactId,
      required String email,
      required bool received,
      required int amount,
      DateTime? date}) async {
    final person = await _khataServices.updatePerson(
        contactId: contactId, email: email, received: received, amount: amount);
    updatePersonCache(person);
  }

  Future<void> getPerson({
    required String contactId,
    required String email,
  }) async {
    final person = await _khataServices.getPerson(
      contactId: contactId,
      email: email,
    );
    updatePersonCache(person);
  }

  // INFO : add a person to the global person cache
  void addPersonCache(PersonDatabase person) {
    print("adding to person cache");
    personsCache.add(person);
    notifyListeners();
  }

//INFO: update a person in the person cache
  void updatePersonCache(PersonDatabase person) {
    print("updating the person cache");
    personsCache.removeWhere((person_) => person_.id == person.id);
    personsCache.add(person);
    notifyListeners();
  }
}
