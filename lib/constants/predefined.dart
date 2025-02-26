// ignore_for_file: camel_case_types, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iconic/iconic.dart';

enum screenNames { HOME, TRANSACTIONS, CALENDER, PEOPLE, INFORM }

List<IconData> icons_List = [
  Iconic.home,
  Icons.receipt_long,
  Iconic.calendar,
  Iconic.man_head,
  Iconic.info,
];

List<String> icons_Names = [
  "HOME",
  "TRANSACTIONS",
  "CALENDER",
  "PEOPLE",
  "INFORM",
];
//INFO: firestore collection names
const String users_collection_firestore = "users";
const String transaction_collection_firestore = "transaction";
const String person_collection_firestore = "person";

const String uid_feild_users_collection = 'uid';
const String name_feild_users_collection = "name";
const String email_feild_users_collection = 'email';

//INFO: Workmanager
const String check_due_dates_name_workmanager = "check_due_dates";
const String send_due_dates_notifications_task_workmanager =
    "send_due_date_notifications";

//INFO: shared preferences
const String user_email_preference = "user-email";
const String user_logged_in_preference = "user-logged-in";

//INFO: route names
const String home_route = "/home/";
// const String transaction_detail = "/home/";
const String login_route = "/login/";
const String register_route = "/register/";
const String email_verification_route = "/email-verification/";

//INFO: database constants
const String khata_database = "KHATA.db";
const String user_table_khata_database = "user";
const String transaction_table_khata_database = "transactions";
const String person_table_khata_database = "person";
//INFO: user table columns
const String id_column_user_table = "user_id";
const String email_column_user_table = "user_email";
// const String name_column_user_table = "user_name";
const String isEmailVerified_column_user_table = "user_is_email_verified";
//INFO: person table columns
const String id_column_person_table = "person_id";
const String name_column_person_table = "person_name";
const String contactId_column_person_table = "person_contact_id";
const String userId_column_person_table = "person_user_id";
const String phoneNumber_column_person_table = "person_phoner_number";
const String totalamount_column_person_table = "person_total_amount";
const String receivedamount_column_person_table = "person_received_amount";
const String remainingamount_column_person_table = "person_remaining_amount";
const String dueDate_column_person_table = "person_due_date";
// INFO: transaction table columns
const String id_column_transaction_table = "transaction_id";
const String personId_column_transaction_table = "transaction_people_id";
const String userId_column_transaction_table = "transaction_user_id";
const String date_column_transaction_table = "transaction_date";
const String amount_column_transaction_table = "transaction_amount";
const String reason_column_transaction_table = "transaction_reason";
const String recording_column_transaction_table = "transaction_recording";
const String received_column_transaction_table = "transaction_reeieved";
const String isSyncedWithCloud_column_transaction_table =
    "transaction_is_synced_with_cloud";

// $isEmailVerified_column_user_table INTEGER
//INFO: database queries
const String createUserTableQuery = '''
  CREATE TABLE IF NOT EXISTS user (
    $id_column_user_table INTEGER PRIMARY KEY,
    $email_column_user_table TEXT
  )
''';
// $name_column_user_table TEXT

//TODO: make contactid column not unique
const String createPersonTableQuery = '''
  CREATE TABLE IF NOT EXISTS person (
    $id_column_person_table INTEGER PRIMARY KEY,
    $name_column_person_table TEXT,
    $contactId_column_person_table TEXT ,
    $userId_column_person_table TEXT ,
    $phoneNumber_column_person_table TEXT ,
    $totalamount_column_person_table INTEGER DEFAULT 0,
    $receivedamount_column_person_table INTEGER DEFAULT 0,
    $remainingamount_column_person_table INTEGER DEFAULT 0,
    $dueDate_column_person_table TEXT
  )
''';

const String createTransactionTableQuery = '''
  CREATE TABLE IF NOT EXISTS transactions (
    $id_column_transaction_table INTEGER PRIMARY KEY,
    $personId_column_transaction_table INTEGER,
    $userId_column_transaction_table INTEGER,
    $date_column_transaction_table TEXT,
    $reason_column_transaction_table TEXT,
    $recording_column_transaction_table TEXT,
    $amount_column_transaction_table INTEGER,
    $isSyncedWithCloud_column_transaction_table INTEGER,
    $received_column_transaction_table INTEGER,
    FOREIGN KEY ($personId_column_transaction_table) REFERENCES person ($id_column_person_table),
    FOREIGN KEY ($userId_column_transaction_table) REFERENCES user ($id_column_user_table)
  )
''';
