import 'dart:async';
import 'dart:ui';

import 'package:app_1/colors/primary_colors.dart';
import 'package:app_1/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatefulWidget {
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool changeRad = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    print("initState called");
    // startTimer(); // Start the periodic timer
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        changeRad = !changeRad; // Toggle the value
        print("ChangeRad toggled: $changeRad"); // Debug output
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  void handleSearchIconClick(CounterProvider provider) {
    provider.toggle_searchTextFeildOpenStatus();
    provider.set_menuOptionsOpenStatus();
  }

  void handleMenuIconClick(CounterProvider provider) {
    provider.toggle_menuOptionsOpenStatus();
    provider.set_searchTextFeildOpenStatus();
  }

  @override
  Widget build(BuildContext context) {
    print("Building MainAppBar");
    final provider = Provider.of<CounterProvider>(context, listen: false);

    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 70,
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
                        blurRadius: 10, // Shadow blur
                        spreadRadius: 0, // Shadow spread
                        offset:
                            Offset(0, 5), // Shift shadow downward (only bottom)
                      ),
                    ],
                  ),
                  child: iconRow(provider),
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
                            color: Colors.black.withAlpha(60), // Shadow color
                            blurRadius: 10, // Shadow blur
                            spreadRadius: 0, // Shadow spread
                            offset: Offset(
                                0, 5), // Shift shadow downward (only bottom)
                          ),
                        ]),
                    child: Text(
                      "KHATA",
                      style: TextStyle(
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
  }

  Row iconRow(CounterProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
