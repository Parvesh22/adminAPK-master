import 'package:flutter/material.dart';

class ResetPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.42;

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
                            height: 170,
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
                              child: Text("Set Your New Admin App Password", style: TextStyle(fontWeight: FontWeight.bold,),),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Center(
                              child: Text("Discover Amazing Thing Near Around You", ),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                            child: TextField(
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
                                hintText: 'New Password',
                                prefixIcon: const Icon(
                                  Icons.lock_open_sharp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 50, left: 25, right: 25),
                            transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                            child: TextField(
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
                                  hintText: 'Confirm Password',
                                  prefixIcon: const Icon(
                                    Icons.lock_open_sharp,
                                    color: Colors.black,
                                  ),
                                  prefixText: ' ',
                                  suffixStyle: const TextStyle(color: Colors.black)),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only( left: 20, right: 20, bottom: 36),
                            width: 320,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
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
                                'Reset',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      height: 60,
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