import 'dart:async';

import 'package:app_1/services/database/database_exceptions.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';

class DatabaseProvider with ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  //INFO : list of caches
  List<PersonDatabase> personsCache = [];
  final StreamController<List<PersonDatabase>> _personStreamController =
      StreamController<List<PersonDatabase>>.broadcast();

  Stream<List<PersonDatabase>> get personStream =>
      _personStreamController.stream;

  List<UserDatabase> userCache = [];
  List<TransactionDatabase> transactionCache = [];

  //INFO: global database service
  final KhataDatabaseServices _khataServices = KhataDatabaseServices();

  //INFO: constructor
  DatabaseProvider() {
    initializeDatabase();
  }
  //INFO: main initialize function
  Future<void> initializeDatabase() async {
    print("initialzing database");
    // INFO: initialize the database
    await _khataServices.getDatabase();
    //INFO: getting all the persons
    final persons = await _khataServices.getAllPerson();
    personsCache = persons.toList();
    _personStreamController.add(personsCache);
    print("added porsons to person cache");
    //TODO: getting all the users

    //INFO : get all transactions
    final transactions = await _khataServices.getAllTransactions();
    transactionCache = transactions.toList();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> getUser({required String email}) async {
    await _khataServices.getUser(email: email);
  }

  Future<void> createPerson({
    required String contactId,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final person = await _khataServices.createPerson(
          contactId: contactId, name: name, phoneNumber: phoneNumber);
      addPersonCache(person);
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
        contactId: contactId, received: received, amount: amount);
    updatePersonCache(person);
  }

  Future<void> getPerson({
    required String contactId,
  }) async {
    final person = await _khataServices.getPerson(contactId: contactId);
    updatePersonCache(person);
  }

  // INFO : add a person to the global person cache
  void addPersonCache(PersonDatabase person) {
    print("adding to person cache");
    personsCache.add(person);
    _personStreamController.add(personsCache);
    notifyListeners();
  }

//INFO: update a person in the person cache
  void updatePersonCache(PersonDatabase person) {
    print("updating the person cache");
    personsCache.removeWhere((person_) => person_.id == person.id);
    personsCache.add(person);
    _personStreamController.add(personsCache);
    notifyListeners();
  }
}
