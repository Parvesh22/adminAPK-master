import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '/components/drawer/custom_drawer.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Footer extends StatefulWidget{
     @override
     _Footer createState() => _Footer();
}

class _Footer extends State<Footer>{
  void RemoveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
  void _showConfirmationDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform logout action here
                Navigator.of(context).pop(); // Close the dialog
                RemoveToken();
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if(selecteindex == 0){
                  setState(() {
                    selecteindex= 1;
                  });
                }

                print(selecteindex);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

    int selecteindex = 1;
    @override
    Widget build(BuildContext context){
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 20),
            child: FFNavigationBar(
              theme: FFNavigationBarTheme(
                  selectedItemBackgroundColor:Color(0xFFff753a),
                  selectedItemIconColor: Colors.white,
                  selectedItemLabelColor: Colors.black,
                  unselectedItemIconColor: Color(0xFFff753a),
                  unselectedItemLabelColor: Color(0xFFff753a)
              ),
              selectedIndex: selecteindex,
              onSelectTab: (index) {
                setState(() {
                  selecteindex= index;
                });

                if(index == 0){
                  _showConfirmationDialog(context);
                }

                if(index == 2){
                   Navigator.pushNamed(context, '/profile');
                }
              },
              items: [
                FFNavigationBarItem(
                  iconData: Icons.login,
                  label: 'Logout',
                ),
                FFNavigationBarItem(
                  iconData: Icons.home,
                  label: 'Home',
                ),
                FFNavigationBarItem(
                  iconData: Icons.people,
                  label: 'Profile',
                ),
              ],
            ),
          );
    }
}