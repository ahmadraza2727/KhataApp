import 'package:app_1/components/main_appbar.dart';
import 'package:app_1/components/menu_options.dart';
import 'package:app_1/components/search_feild.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/screens/calender_screen.dart';
import 'package:app_1/screens/home_screen.dart';
import 'package:app_1/screens/inform_screen.dart';
import 'package:app_1/screens/people_screen.dart';
import 'package:app_1/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CenterApp extends StatelessWidget {
  const CenterApp({super.key});
  @override
  Widget build(BuildContext context) {
    // CounterProvider counterPorvider =
    //     Provider.of<CounterProvider>(context, listen = false);

    List<Widget> screens = [
      // ContactListScreen(),
      HomeScreen(),
      TransactionScreen(),
      CalenderScreen(),
      PeopleScreen(),
      InformScreen(),
    ];

    return Scaffold(
      backgroundColor: Primarycolors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            // INFO: main app column
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MainAppBar(),
                SearchFeild(),
                MenuOptions(),
                Expanded(
                  // INFO : indexed stack
                  child: Consumer<NavigationProvider>(
                    builder: (context, counterProvider, child) => IndexedStack(
                      index: counterProvider.getCurrentPage() as int,
                      children: screens,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
