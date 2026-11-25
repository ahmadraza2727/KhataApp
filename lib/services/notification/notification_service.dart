import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_1/services/database/local_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body, int personId) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'due_date_channel',
      'Due Date Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(personId, title, body, details);
  }

  Future<void> showDueNotifications(String userEmail) async {
    final db = LocalKhataDatabaseServices();
    await db.open();
    final persons =
        await db.getAllPersonsWithEmail(userEmail); // Async DB query

    final now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Compute only the filtering & notification check
    final List<PersonDatabase> duePersons = await compute(_filterDuePersons, {
      'persons': persons,
      'currentDate': now,
    });

    for (var person in duePersons) {
      String key = "notified_${person.id}";
      bool alreadyNotified = prefs.getBool(key) ?? false;

      if (!alreadyNotified) {
        await showNotification(
          "Payment Due: ${person.name}",
          "Remaining: ${person.remainingamount} PKR. Due Today: ${DateFormat.yMMMd().format(person.dueDate)}",
          person.id,
        );
        await prefs.setBool(key, true); // Mark as notified
      }
    }
  }

// Filtering logic runs in an isolate
  List<PersonDatabase> _filterDuePersons(Map<String, dynamic> data) {
    List<PersonDatabase> persons = List<PersonDatabase>.from(data['persons']);
    DateTime currentDate = data['currentDate'];

    return persons
        .where((person) => _isDueToday(person.dueDate, currentDate))
        .toList();
  }

  bool _isDueToday(DateTime dueDate, DateTime now) {
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  Future<void> clearNotificationsOnLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _notificationsPlugin.cancelAll(); // Cancel all notifications
  }
}
