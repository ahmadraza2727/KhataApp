import 'package:app_1/components/main_appbar.dart';
import 'package:app_1/components/menu_options.dart';
import 'package:app_1/components/search_feild.dart';
import 'package:app_1/constants/primary_colors.dart';
import 'package:app_1/provider.dart';
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
    CounterProvider provider = Provider.of(context);

    List<Widget> screens = [
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
                  child: SingleChildScrollView(
                    // INFO : indexed stack
                    child: IndexedStack(
                      index: provider.getCurrentPage() as int,
                      children: screens,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//   SizedBox newMethodsizebox() {
//     return SizedBox(
//       width: double.infinity,
//       child: Card(
//           color: Colors.blueGrey,
//           elevation: 10,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: 10,
//                 sigmaY: 10,
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       "this is the text ",
//                       style: TextStyle(backgroundColor: Colors.redAccent),
//                     ),
//                     Icon(Icons.price_change_sharp)
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
}
