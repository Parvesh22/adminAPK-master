import 'package:flutter/material.dart';
import 'bargrp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/components/drawer/custom_drawer.dart';
import 'footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/StudentAttd_controller.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '/components/drawer/custom_drawer.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'profile.dart';


class StudentProfile extends StatefulWidget {
  _StudentProfile createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  final obj = StudentAttdController();
  String token = '';
  dynamic data;

  String Institution = '';
  String Email = '';
  String PhoneNo = '';
  String UserName = '';
  String ProfileImg = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      Institution = prefs.getString('School') ?? '';
      PhoneNo = prefs.getString('PhoneNo') ?? '';
      Email = prefs.getString('Email') ?? '';
      UserName = prefs.getString('UserName') ?? '';
      ProfileImg = prefs.getString('ProfileImg') ?? '';
    });
  }

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
  int selecteindex = 2;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.45;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFFff753a),
          ),
        ),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Color(0xFFff753a),
              ), // Change the icon here
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // Header Section
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 2),
            decoration: BoxDecoration(
              color: Color(0xFFFF7F50),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Shadow color
                  blurRadius: 5.0, // Spread of the shadow
                  offset: Offset(0, 4), // Offset from the top
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(height: 300),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(
                    3.0), // Adjust the padding for the border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Border color
                ),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(
                    ProfileImg,
                  ),
                ),
              ),
              Center(
                child: Card(
                  elevation: 5.0, // Add elevation for a raised effect
                  margin: EdgeInsets.all(10.0), // Add margin for spacing
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0), // Add rounded corners
                  ),
                  child: Container(
                    height: gapHeight,
                    width: gapHeight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(height: 16.0),
                          Text(
                            '${UserName}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'School Admin',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'School:',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${Institution}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email),
                              SizedBox(width: 8.0),
                              Text('${Email}'),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone),
                              SizedBox(width: 8.0),
                              Text('${PhoneNo}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: AnimatedSwitcher(
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

            if(index == 1){
              Navigator.pushNamed(context, '/home');
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
      )
    );
  }
}
