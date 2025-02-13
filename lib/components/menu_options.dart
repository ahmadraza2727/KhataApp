import 'package:app_1/constants/predefined.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/provider.dart';
import 'package:flutter/material.dart';
import 'package:iconic/iconic.dart';
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
    print('building menu options screen');
    final provider = Provider.of<CounterProvider>(context);

    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Container for Sliding Effect
        AnimatedContainer(
          duration: Duration(milliseconds: 400), // Animation duration
          height: provider.menuOptionsOpenStatus ? 60 : 0, // Dynamic height
          curve: Curves.fastOutSlowIn, // Smooth animation curve
          child: provider.menuOptionsOpenStatus
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  margin: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(icons_List.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            provider.setCurrentPage(index);
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: provider.getCurrentPage() == index
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
                  ),
                )
              : null, // Hide the widget when not visible
        ),
      ],
    );
  }
}
