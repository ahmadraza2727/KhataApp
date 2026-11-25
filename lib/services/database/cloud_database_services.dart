// import 'package:app_1/services/database/local_database_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void listenForCloudTransactions(
//   String email,
//   String userId,
//   LocalKhataDatabaseServices db,
// ) async {
// // print("listening for firestore updates $email and id $userId");
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final user = await db.getUser(email: email);
//   firestore
//       .collection("users")
//       .doc(userId)
//       .collection("persons")
//       .snapshots()
//       .listen((personsSnapshot) {
//     for (var personDoc in personsSnapshot.docs) {
//       String personId = personDoc.id;
//
//       firestore
//           .collection("users")
//           .doc(userId)
//           .collection("persons")
//           .doc(personId)
//           .collection("transactions")
//           .snapshots()
//           .listen((transactionsSnapshot) async {
//         for (var transactionDoc in transactionsSnapshot.docs) {
//           final data = transactionDoc.data();
//           final int transactionId = int.parse(transactionDoc.id);
//
//           TransactionDatabase transaction = TransactionDatabase(
//             id: transactionId,
//             personId: int.parse(personId),
//             userId: user.id,
//             amount: data["amount"],
//             date: DateTime.parse(data["date"]),
//             isSyncedWithCloud: true,
//             received: data["received"],
//             reason: data["reason"],
//             recording: data["recording"],
//           );
//
//           // Check if this transaction exists in local database
//           bool existsInLocal = await db.transactionExists(transactionId);
//
//           if (!existsInLocal) {
//             await db.createTransactionFromCloud(td: transaction, user:user);
//             // print(
//                 // "Synced new transaction ${transaction.id} from Cloud to Local.");
//           }
//         }
//       });
//     }
//   });
// }
