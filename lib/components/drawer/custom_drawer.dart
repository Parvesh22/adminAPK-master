import 'bottom_user_info.dart';
import 'custom_list_tile.dart';
import 'header.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color(0xFFFF7F50),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                   isCollapsed: _isCollapsed,
                   icon: Icons.home,
                   title: 'Home',
                   infoCount: 0,
              ),
              GestureDetector(
                child: CustomListTile(
                  isCollapsed: _isCollapsed,
                  icon: Icons.person,
                  title: 'Student Attendance',
                  infoCount: 0,
                ),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.person_pin_rounded,
                title: 'Staff Attendance',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.telegram_sharp,
                title: 'Weekly Test',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_work,
                title: 'HomeWork',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.school,
                title: 'Exam Result',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.account_balance,
                title: 'Fee Report',
                infoCount: 0,
              ),
              const Divider(color: Colors.grey),
              const Spacer(),
              //CustomListTile(
                //isCollapsed: _isCollapsed,
                //icon: Icons.notifications,
               // title: 'Notifications',
                //infoCount: 2,
              //),
              const SizedBox(height: 10),
              BottomUserInfo(isCollapsed: _isCollapsed),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
