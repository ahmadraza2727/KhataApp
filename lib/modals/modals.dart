import 'package:app_1/modals/contact_modal.dart';
import 'package:app_1/modals/reauthentication_modal.dart';
import 'package:app_1/modals/transaction_for_person_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void showTransactionModal(
  BuildContext context,
  void Function(Contact) onContactSelected,
  Future<bool> Function(Map<String, dynamic>) onDoneModal,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) => Builder(
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: CreateTransactionModal(
          onContactSelected: onContactSelected,
          onDoneModal: onDoneModal,
        ),
      ),
    ),
  ).whenComplete(() {});
}

void showTransactionModalForPerson(
  BuildContext context,
  Future<void> Function(Map<String, dynamic>) onDoneModal,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) => Builder(
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: CreateTransactionForPersonModal(
          onDoneModal: onDoneModal,
        ),
      ),
    ),
  ).whenComplete(() {});
}

void showReauthenticationModal(
  BuildContext context,
  Future<void> Function(String email, String password) onDoneModal,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) => Builder(
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: CreateReauthenticationModal(
          onDoneModal: onDoneModal,
        ),
      ),
    ),
  ).whenComplete(() {});
}
