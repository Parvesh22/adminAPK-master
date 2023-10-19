import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawerHeader extends StatefulWidget{
    final bool isColapsed;
    const CustomDrawerHeader({
      Key? key,
      required this.isColapsed,
    }) : super(key: key);
    @override
    _CustomDrawerHeader createState() => _CustomDrawerHeader();
}


class _CustomDrawerHeader extends State<CustomDrawerHeader>{
  void initState() {
    super.initState();
    getToken();
  }
  String Institution = '';
  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Institution = prefs.getString('Institution') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/login_img.png', // Replace with the actual path to your logo asset
            width: 50,
            height: 50,
          ),
          if (widget.isColapsed) const SizedBox(width: 10),
          if (widget.isColapsed)
             Expanded(
              flex: 3,
              child: Text(
                '${Institution}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          if (widget.isColapsed) const Spacer(),
        ],
      ),
    );
  }
}
