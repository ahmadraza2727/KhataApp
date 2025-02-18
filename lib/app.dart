import 'package:app_1/components/main_appbar.dart';
import 'package:app_1/components/menu_options.dart';
import 'package:app_1/components/search_feild.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/screens/calender_screen.dart';
import 'package:app_1/screens/home_screen.dart';
import 'package:app_1/screens/inform_screen.dart';
import 'package:app_1/screens/people_screen.dart';
import 'package:app_1/screens/transaction_screen.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/database/database_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CenterApp extends StatefulWidget {
  const CenterApp({super.key});

  @override
  State<CenterApp> createState() => _CenterAppState();
}

class _CenterAppState extends State<CenterApp> {
  // late Future<UserDatabase> user;
  // late DatabaseProvider provider;
  @override
  void initState() {
    // provider = Provider.of<DatabaseProvider>(
    // context,
    // listen: false,
    // );
//
    // user = provider.getUser(
    // email: AuthServices.firebase().currentUser!.email!.toString());
//
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("building center app ");
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
      body: Builder(builder: (context) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: Text("waitin foe user"));
        //     }
        //
        //     if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     }
        return SafeArea(
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
                      builder: (context, navigationProvider, child) {
                        return GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              navigationProvider.navigateLeft();
                            } else if (details.primaryVelocity! < 0) {
                              navigationProvider.navigateRight();
                            }
                          },
                          onVerticalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              navigationProvider
                                  .set_menuOptionsOpenStatus(true);
                              // setState(() => _swipeDirection = "Swiped Down");
                            } else if (details.primaryVelocity! < 0) {
                              navigationProvider.set_menuOptionsOpenStatus();
                              // setState(() => _swipeDirection = "Swiped Up");
                            }
                          },
                          child: IndexedStack(
                            index: navigationProvider.getCurrentPage() as int,
                            children: screens,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
