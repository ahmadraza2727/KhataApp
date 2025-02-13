import 'dart:async';
import 'dart:io';

import 'package:app_1/constants/predefined.dart';
import 'package:app_1/services/auth/auth_user.dart';
import 'package:app_1/services/database/database_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDatabase {
  final int id;
  final int personId;
  final int userId;
  final int amount;
  final DateTime date;
  final bool isSyncedWithCloud;
  final bool received;
  final String reason;

  // PersonDatabase? person;
  // UserDatabase? user;
  TransactionDatabase({
    required this.id,
    required this.personId,
    required this.userId,
    required this.amount,
    required this.date,
    required this.isSyncedWithCloud,
    required this.received,
    required this.reason,
    // this.person,
    // this.user,
  });
  TransactionDatabase.fromRow(
    Map<String, Object?> map,
    // {
    // this.person,
    // this.user,
    // }
  )   : id = map[id_column_transaction_table] as int,
        personId = map[personId_column_transaction_table] as int,
        userId = map[userId_column_transaction_table] as int,
        amount = map[amount_column_transaction_table] as int,
        date = DateTime.parse(map[date_column_transaction_table] as String),
        reason = map[reason_column_transaction_table] as String,
        received = (map[received_column_transaction_table] == 1),
        isSyncedWithCloud =
            (map[isSyncedWithCloud_column_transaction_table] == 1);
  @override
  bool operator ==(covariant TransactionDatabase other) {
    return (id == other.id);
  }

  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return "Transaction , ID - $id, PersonId - $personId, UserId - $userId, amount - $amount, Date - $date, IsSyncedWithCloud - $isSyncedWithCloud";
  }
}

class PersonDatabase {
  final int id;
  final String name;
  final String contactId;
  final String phoneNumber;
  final int totalamount;
  final int receivedAmount;
  final int remainingamount;
  final DateTime dueDate;
  PersonDatabase({
    required this.id,
    required this.name,
    required this.contactId,
    required this.phoneNumber,
    required this.dueDate,
    this.totalamount = 0,
    this.receivedAmount = 0,
    this.remainingamount = 0,
  });
  PersonDatabase.fromRow(Map<String, Object?> map)
      : id = map[id_column_person_table] as int,
        name = map[name_column_person_table] as String,
        phoneNumber = map[phoneNumber_column_person_table] as String,
        dueDate = DateTime.parse(map[dueDate_column_person_table] as String),
        totalamount = map[totalamount_column_person_table] as int,
        receivedAmount = map[receivedamount_column_person_table] as int,
        remainingamount = map[remainingamount_column_person_table] as int,
        contactId = map[contactId_column_person_table] as String;
  @override
  bool operator ==(covariant PersonDatabase other) {
    return (id == other.id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "Person , ID - $id, ContactId - $contactId";
  }
}

class UserDatabase {
  final int id;
  final String email;

  UserDatabase({
    required this.id,
    required this.email,
  });
  UserDatabase.fromRow(Map<String, Object?> map)
      : id = map[id_column_user_table] as int,
        email = map[email_column_user_table] as String;
  @override
  bool operator ==(covariant UserDatabase other) {
    return (id == other.id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "User , ID - $id, Email - $email";
  }
}

class KhataDatabaseServices {
  // Future<void> initialize() async {
  //   await getDatabase();
  //   await cacheAllPerson();
  // }

  // Private constructor
  KhataDatabaseServices._internal();

  // The single instance of the class
  static final KhataDatabaseServices _khataService =
      KhataDatabaseServices._internal();

  // Factory constructor that returns the same instance

  factory KhataDatabaseServices() => _khataService;

  // List<PersonDatabase> _persons = [];
  //
  // final _personStreamController =
  //     StreamController<List<PersonDatabase>>.broadcast();
  //
  // Future<void> cacheAllPerson() async {
  //   try {
  //     final persons = await getAllPerson();
  //     print("[DEBUG] Cached ${persons.length} persons");
  //     _persons = persons.toList();
  //     _personStreamController.sink.add(_persons); // Force emit the new list
  //   } catch (e) {
  //     print("[ERROR] cacheAllPerson: $e");
  //     _personStreamController.sink.addError(e);
  //   }
  // }

//INFO : this is the global database instance
  static Database? _database;
//INFO: open the database
  Future<void> open() async {
    if (_database != null) return;

    try {
      final Directory docDir = await getApplicationDocumentsDirectory();
      final String dbPath = join(docDir.path, khata_database);

      _database = await openDatabase(
        dbPath,
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) async {
          // Create tables if they don't exist
          await db.execute(createUserTableQuery);
          await db.execute(createPersonTableQuery);
          await db.execute(createTransactionTableQuery);
        },
      );

      // Load initial data after opening
      // await cacheAllPerson();
    } catch (e) {
      print("[ERROR] openDatabase: $e");
      rethrow;
    }
  }

//INFO:close the database instance
  Future<void> close() async {
    final database = _database;
    // INFO: if database does not exists
    if (database == null) {
      throw DatabaseNotFoundException();
    } else {
      await database.close();
      _database = null;
    }
  }

  //INFO: create a database instance of not exist and return
  Future<Database> getDatabase() async {
    if (_database == null) {
      try {
        await open();
      } on MissingPlatformDirectoryException {
        rethrow;
      }
    }
    return _database!;
  }

  //INFO: delete a database user object
  Future<void> deleteUser({required String email}) async {
    final Database database = await getDatabase();
    final int deleteCount = await database.delete(
      user_table_khata_database,
      where: "$email_column_user_table = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw DatabaseCouldNotDeleteUser();
    }
  }

  // INFO : create a database user from an AuthUser
  Future<UserDatabase> createUserFromAuthUser({required AuthUser user}) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      user_table_khata_database,
      limit: 1,
      where: "$email_column_user_table = ?",
      whereArgs: [user.email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw DatabaseUserAlreadyExistsException();
    }
    int userId = await database.insert(
      user_table_khata_database,
      {
        email_column_user_table: user.email.toLowerCase(),
      },
    );
    final ud = UserDatabase(id: userId, email: user.email);
    return ud;
  }

//INFO: create a databse user from email
  Future<UserDatabase> createUser({required String email}) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      user_table_khata_database,
      limit: 1,
      where: "$email_column_user_table = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw DatabaseUserAlreadyExistsException();
    }
    int userId = await database.insert(
      user_table_khata_database,
      {
        email_column_user_table: email.toLowerCase(),
      },
    );
    final ud = UserDatabase(id: userId, email: email);
    return ud;
  }

// INFO : get a database user from an AuthUser
  Future<UserDatabase> getUserFromAuthUser({required AuthUser user}) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      user_table_khata_database,
      limit: 1,
      where: "$email_column_user_table = ?",
      whereArgs: [user.email.toLowerCase()],
    );
    if (result.isEmpty) {
      final ud = await createUser(email: user.email.toLowerCase());
      return ud;
    }
    final ud = UserDatabase.fromRow(result.first);
    return ud;
  }

//INFO:  get a databse user from email
  Future<UserDatabase> getUser({required String email}) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      user_table_khata_database,
      limit: 1,
      where: "$email_column_user_table = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      final ud = await createUser(email: email);
      return ud;
    }
    final ud = UserDatabase.fromRow(result.first);
    return ud;
  }

// INFO: create a person databas eobject
  Future<PersonDatabase> createPerson({
    required String contactId,
    required String name,
    required String phoneNumber,
  }) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      person_table_khata_database,
      limit: 1,
      where: "$contactId_column_person_table = ?",
      whereArgs: [contactId],
    );

    if (result.isNotEmpty) {
      throw DatabasePersonAlreadyExistsException();
    }

    int personId = await database.insert(
      person_table_khata_database,
      {
        name_column_person_table: name,
        contactId_column_person_table: contactId,
        phoneNumber_column_person_table: phoneNumber,
        totalamount_column_person_table: 0,
        remainingamount_column_person_table: 0,
        receivedamount_column_person_table: 0,
        dueDate_column_person_table: DateTime.now().toIso8601String(),
      },
    );
    final pd = PersonDatabase(
      id: personId,
      name: name,
      phoneNumber: phoneNumber,
      contactId: contactId,
      dueDate: DateTime.now(),
    );

    return pd;
  }

  Future<PersonDatabase> getPerson({
    required String contactId,
  }) async {
    final Database database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      person_table_khata_database,
      limit: 1,
      where: "$contactId_column_person_table = ?",
      whereArgs: [contactId],
    );
    if (result.isEmpty) {
      throw DatabasePersonNotFoundException();
    }
    final pd = PersonDatabase.fromRow(result.first);

    return pd;
  }

  Future<Iterable<PersonDatabase>> getAllPerson() async {
    final Database database = await getDatabase();
    try {
      final List<Map<String, Object?>> result =
          await database.query(person_table_khata_database);
      print("[DEBUG] getAllPerson found ${result.length} entries");
      return result.map((person) => PersonDatabase.fromRow(person));
    } catch (e) {
      print("[ERROR] getAllPerson: $e");
      rethrow;
    }
  }

  // Future<Iterable<PersonDatabase>> ____getAllPerson() async {
  //   final Database database = await getDatabase();
  //   final List<Map<String, Object?>> result = await database.query(
  //     person_table_khata_database,
  //   );
  //   return result.map((person) => PersonDatabase.fromRow(person));
  // }
  //
  // Future<Iterable<PersonDatabase>> __getAllPerson() async {
  //   final Database database = await getDatabase();
  //   final List<Map<String, Object?>> result = await database.query(
  //     person_table_khata_database,
  //   );
  //   if (result.isEmpty) {
  //     throw DatabasePersonNotFoundException();
  //   }
  //   final pd = result.map((person) => PersonDatabase.fromRow(person));
  //   print("getting all persons");
  //   print(pd);
  //   return pd;
  // }

  Future<PersonDatabase> updatePerson(
      {required String contactId,
      required bool received,
      required int amount,
      DateTime? date}) async {
    final Database database = await getDatabase();
    final person = await getPerson(contactId: contactId);
    int remainingamount = person.remainingamount;
    int recievedamount = person.receivedAmount;
    int totalamount = person.totalamount;
    if (received) {
      if (person.totalamount == 0 && amount > 0) {
        throw DatabasePersonamountGreaterThatTotalamountException();
      }
      if (person.totalamount > 0 && amount > 0 && person.totalamount < amount) {
        throw DatabasePersonamountGreaterThatTotalamountException();
      }
      if (person.totalamount > 0 && amount > 0 && person.totalamount > amount) {
        remainingamount -= amount;
        recievedamount += amount;
      }
    }

    if (!received) {
      if (amount > 0) {
        remainingamount += amount;
        totalamount += amount;
      }
    }
    final int result = await database.update(
        person_table_khata_database,
        {
          totalamount_column_person_table: totalamount,
          receivedamount_column_person_table: recievedamount,
          remainingamount_column_person_table: remainingamount,
        },
        where: "$id_column_person_table = ?",
        whereArgs: [person.id]);
    if (result == 0) {
      throw DatabasePersonNotUpdatedException();
    }
    if (date != null) {
      final int result = await database.update(
          person_table_khata_database,
          {
            dueDate_column_person_table: date.toIso8601String(),
          },
          where: "$contactId_column_person_table = ?",
          whereArgs: [person.contactId]);
      if (result == 0) {
        throw DatabasePersonNotUpdatedException();
      }
    }
    final pd = await getPerson(contactId: person.contactId);
    return pd;
  }

  Future<TransactionDatabase> createTransaction({
    required UserDatabase owner,
    required PersonDatabase person,
    required int amount,
    required DateTime date,
    required String reason,
    required bool received,
    bool isSyncedWithCloud = false,
  }) async {
    final Database database = await getDatabase();
    final ud = await getUser(email: owner.email);
    if (ud != owner) {
      throw DatabaseUserNotFoundException();
    }
    final pd = await getPerson(contactId: person.contactId);

    int transactionId = await database.insert(
      transaction_table_khata_database,
      {
        personId_column_transaction_table: person.id,
        userId_column_transaction_table: owner.id,
        amount_column_transaction_table: amount,
        date_column_transaction_table: date.toIso8601String(),
        reason_column_transaction_table: reason,
        received_column_transaction_table: received,
        isSyncedWithCloud_column_transaction_table: isSyncedWithCloud ? 1 : 0,
      },
    );
    await updatePerson(
      contactId: pd.contactId,
      received: received,
      amount: amount,
    );

    final td = TransactionDatabase(
      id: transactionId,
      personId: person.id,
      userId: owner.id,
      date: date,
      amount: amount,
      isSyncedWithCloud: isSyncedWithCloud,
      reason: reason,
      received: received,
    );
    return td;
  }

  Future<void> deleteTransaction({required int id}) async {
    final database = await getDatabase();
    final t = await database.query(
      transaction_table_khata_database,
      limit: 1,
      where: "$id_column_transaction_table = ?",
      whereArgs: [id],
    );
    final transaction = t.first;

    final per = await database.query(
      person_table_khata_database,
      where: "$id_column_person_table = ?",
      whereArgs: [transaction[personId_column_transaction_table] as int],
    );
    final person = PersonDatabase.fromRow(per.first);
    await updatePerson(
      contactId: person.contactId,
      received: !(transaction[received_column_transaction_table] as bool),
      amount: transaction[amount_column_transaction_table] as int,
    );
    final deleteCount = await database.delete(
      transaction_table_khata_database,
      where: "$id_column_transaction_table = ?",
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw DatabaseTransactionNotFoundException();
    }
  }

  Future<TransactionDatabase> getTransaction({required int id}) async {
    final database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      transaction_table_khata_database,
      limit: 1,
      where: "$id_column_transaction_table = ?",
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw DatabaseTransactionNotFoundException();
    }
    final td = TransactionDatabase.fromRow(result.first);
    return td;
  }

  Future<Iterable<TransactionDatabase>> getTransactionsOfAPerson(
      {required int contactId}) async {
    final database = await getDatabase();
    final p = await database.query(
      transaction_table_khata_database,
      limit: 1,
      where: "$contactId_column_person_table = ?",
      whereArgs: [contactId],
    );
    final person = PersonDatabase.fromRow(p.first);
    final List<Map<String, Object?>> result = await database.query(
      transaction_table_khata_database,
      limit: 1,
      where: "$personId_column_transaction_table = ?",
      whereArgs: [person.id],
    );
    if (result.isEmpty) {
      throw DatabaseTransactionNotFoundException();
    }
    final td =
        result.map((transaction) => TransactionDatabase.fromRow(transaction));
    return td;
  }

  Future<Iterable<TransactionDatabase>> getAllTransactions() async {
    final database = await getDatabase();
    final List<Map<String, Object?>> result = await database.query(
      transaction_table_khata_database,
    );
    final td = result.map((noteRow) => TransactionDatabase.fromRow(noteRow));
    return td;
  }
}
