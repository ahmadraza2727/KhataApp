import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuOptions extends StatefulWidget {
  const MenuOptions({super.key});

  @override
  State<MenuOptions> createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  // bool _isVisible = false; // Controls the visibility of the input field

  @override
  Widget build(BuildContext context) {
    // print('building menu options screen');
    final navigationProvider = Provider.of<NavigationProvider>(context);

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
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Container for Sliding Effect
          AnimatedContainer(
            duration: Duration(milliseconds: 400), // Animation duration
            height: navigationProvider.menuOptionsOpenStatus ? 60 : 0, // Dynamic height
            curve: Curves.fastOutSlowIn, // Smooth animation curve
            child: navigationProvider.menuOptionsOpenStatus
                ? Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(icons_List.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            navigationProvider.setCurrentPage(index);
                          },
                          child: Card(
                            elevation: 2,
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 10,
                              right: 10,
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: navigationProvider.getCurrentPage() == index
                                      ? Primarycolors.darkColor
                                      : Primarycolors.primaryColor,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Icon(icons_List[index])),
                          ),
                        );
                      }),
                    ),
                  )
                : null, // Hide the widget when not visible
          ),
        ],
      ),
    );
  }
}
