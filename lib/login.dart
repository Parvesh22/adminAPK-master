import 'package:flutter/material.dart';
import '../controller/AuthController.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final authService = AuthController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passcontroller = TextEditingController();
  bool validation = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.42;
    double gapHeights = screenHeight * 0.09;
    double margin = screenHeight * 0.074;
    double cardheight =  screenHeight * 0.209;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            height: gapHeight,
            decoration: BoxDecoration(
              color: Color(0xFFFF7F50),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Center(
                      child: Align(
                        alignment: Alignment.topLeft,
                        )
                  ),
                ),
              ],
            ),
          ),
          Column(
             children: [
               Container(
                 margin: EdgeInsets.only(top: 5),
                 child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 10),
                          elevation: 5,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: 150,
                                height: cardheight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/login_img.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Center(
                                  child: Text("Welcome to Admin App", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Center(
                                  child: Text("", ),),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                                child: TextField(
                                  controller: _namecontroller,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder( // Set default border radius here
                                      borderRadius: BorderRadius.circular(20.0), // Set your desired default radius
                                      borderSide: new BorderSide(color: Colors.black),
                                    ),
                                    hintText: 'Enter UserName',
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50, left: 25, right: 25),
                                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                                child: TextField(
                                  obscureText: obscureText,
                                  controller: _passcontroller,
                                  decoration: new InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder( // Set default border radius here
                                        borderRadius: BorderRadius.circular(20.0), // Set your desired default radius
                                        borderSide: new BorderSide(color: Colors.black),
                                      ),
                                      hintText: 'Enter Password',
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                      prefixText: ' ',
                                      suffixIcon: IconButton(
                                          icon: obscureText ? Icon(Icons.visibility_off_sharp) : Icon(Icons.visibility),
                                          onPressed: (){
                                               if(obscureText){
                                                     setState(() {
                                                       obscureText = false;
                                                     });
                                               }else{
                                                    setState(() {
                                                      obscureText = true;
                                                    });
                                               }
                                          },
                                      ),
                                      suffixStyle: const TextStyle(color: Colors.black)),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: validation
                                    ? Container(
                                  transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                                  key: Key('error-container'),
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Wrong Credentials",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                                    : SizedBox(height: 18),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                                width: 320,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {

                                    Loader.show(context,
                                        isAppbarOverlay: true,
                                        overlayFromTop: 100,
                                        progressIndicator: CircularProgressIndicator(),
                                        themeData: Theme.of(context)
                                            .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
                                        overlayColor: Color(0x99E8EAF6));
                                              final userauth = await authService.signIn(name: _namecontroller.text, password: _passcontroller.text);

                                              if(userauth) {
                                                  Navigator.pushNamed(context, '/home');
                                              }else{
                                                 setState(() {
                                                     validation = true;
                                                 });
                                              }
                                      Loader.hide();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15), // Set the desired border radius here
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>( Color(0xFFFF7F50)), // Set the button background color here
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Center(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, '/setotp');
                                        },
                                        child: Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF7F50),),),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: margin),
                          height: gapHeights,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF7F50),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ],
                 ),
               ),
             ],
          ),
        ],
      ),
    );
  }
}