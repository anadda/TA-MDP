import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:donor_darah/datadualist.dart';
import 'package:donor_darah/main.dart';

import 'package:flutter/material.dart';

import 'profil.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; //default index

  List<Widget> _widgetOptions = [
    HomeScreen(),
    DataDuaList(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        selectedColor: Color(0xff180c20),
        unSelectedColor: Colors.white,
        backgroundColor: Color(0xffe30404),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        enableLineIndicator: true,
        lineIndicatorWidth: 3,
        indicatorType: IndicatorType.Bottom,
        // gradient: LinearGradient(
        //   colors: [Colors.pink, Colors.yellow],
        // ),
        customBottomBarItems: [
          CustomBottomBarItems(
            label: '2014',
            icon: Icons.local_hospital,
          ),
          CustomBottomBarItems(
            label: 'Covid',
            icon: Icons.local_hospital,
          ),
          CustomBottomBarItems(
            label: 'Account',
            icon: Icons.account_box_outlined,
          ),
        ],
      ),
    );
  }
}
