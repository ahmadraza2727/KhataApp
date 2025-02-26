import 'dart:ui';
import 'package:app_1/components/dialogs.dart';
import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/database_provider.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:app_1/services/auth/auth_exceptions.dart';
import 'package:app_1/services/auth/auth_services.dart';
import 'package:app_1/services/database/local_database_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAppBar extends StatefulWidget {
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool changeRad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleVerificationIconClick() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(email_verification_route, (route) => false);
  }

  void handleLoginIconClick() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(login_route, (route) => false);
  }

  void handleLogoutIconClick(DatabaseProvider provider) async {
    final bool confirm = await showConfirmationDialog(
        context, "Are You Sure", "Do you Want To Log Out");
    if (confirm) {
      try {
        await AuthServices.firebase().logout();
        provider.providerLogout();
      } on UserNotLoggedInAuthException {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove(user_email_preference);
        prefs.setBool(user_logged_in_preference, false);
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(home_route, (route) => false);
    }
  }

  void handleSearchIconClick(NavigationProvider provider) {
    provider.set_menuOptionsOpenStatus();
    provider.toggle_searchTextFeildOpenStatus();
  }

  void handleMenuIconClick(NavigationProvider provider) {
    provider.toggle_menuOptionsOpenStatus();
    provider.set_searchTextFeildOpenStatus();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );
    final dbProvider = Provider.of<DatabaseProvider>(
      context,
      listen: false,
    );
    print("Building MainAppBar");

    return Center(
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
              navigationProvider.set_menuOptionsOpenStatus(true);
              // setState(() => _swipeDirection = "Swiped Down");
            } else if (details.primaryVelocity! < 0) {
              navigationProvider.set_menuOptionsOpenStatus();
              // setState(() => _swipeDirection = "Swiped Up");
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 65,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //INFO: Background container
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: 15,
                  bottom: 0,
                  right: 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                        color: (provider.searchTextFeildOpenStatus ||
                                provider.menuOptionsOpenStatus)
                            ? Primarycolors.darkColorFaded
                            : Primarycolors.darkColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular((provider.searchTextFeildOpenStatus ||
                                  provider.menuOptionsOpenStatus)
                              ? 30
                              : 5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(60), // Shadow color
                            blurRadius: 5, // Shadow blur
                            spreadRadius: 0, // Shadow spread
                            offset: Offset(
                                0, 5), // Shift shadow downward (only bottom)
                          ),
                        ],
                      ),
                      // INFO : Icnon row
                      child: iconRow(provider, dbProvider, context),
                    ),
                  ),
                ),
                // INFO: Title
                TweenAnimationBuilder(
                    tween: ColorTween(
                        begin: Primarycolors.darkColor,
                        end: Primarycolors.secondaryColor),
                    duration: Duration(seconds: 5),
                    builder: (context, color, widgets) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        width: 110,
                        height: 53,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withAlpha(60), // Shadow color
                                blurRadius: 10, // Shadow blur
                                spreadRadius: 0, // Shadow spread
                                offset: Offset(0,
                                    5), // Shift shadow downward (only bottom)
                              ),
                            ]),
                        child: Text(
                          "KHATA",
                          style: TextStyle(
                            fontFamily: "Sans",
                            color: Primarycolors.textDark,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                // Company name
                Positioned(
                  left: 60,
                  top: 40,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Primarycolors.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text("Al-Ahmad"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Row iconRow(NavigationProvider provider, DatabaseProvider dbProvider,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (AuthServices.firebase().currentUser != null &&
            !AuthServices.firebase().currentUser!.isEmailVerified)
          InkWell(
            onTap: () => handleVerificationIconClick(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.verified_user, color: Primarycolors.textDark),
            ),
          ),
        if (AuthServices.firebase().currentUser == null)
          InkWell(
            onTap: () => handleLoginIconClick(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.login, color: Primarycolors.textDark),
            ),
          ),
        if (AuthServices.firebase().currentUser != null)
          InkWell(
            onTap: () => handleLogoutIconClick(dbProvider),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.logout, color: Primarycolors.textDark),
            ),
          ),
        InkWell(
          onTap: () => handleSearchIconClick(provider),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.search, color: Primarycolors.textDark),
          ),
        ),
        InkWell(
          onTap: () => handleMenuIconClick(provider),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.menu, color: Primarycolors.textDark),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
