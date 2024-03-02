import 'package:demo4/widget/barcode.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

import 'widget/tqc_appbar.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MainView(),
      debugShowCheckedModeBanner : false,
    ),
  );
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// Views to display
  List<Widget> views = const [
    Barcode(),
    Center(
      child: Text('Account'),
    ),

  ];

  /// The currently selected index of the bar
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// You can use an AppBar if you want to
      appBar: TQCAppbar(""),

      // The row is needed to display the current view
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.qr_code,
                label: 'Barcode',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              // SideNavigationBarItem(
              //   icon: Icons.settings,
              //   label: 'Settings',
              // ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}