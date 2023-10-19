import 'package:flutter/material.dart';

class OtpEntryScreen extends StatefulWidget {
  @override
  _OtpEntryScreenState createState() => _OtpEntryScreenState();
}

class _OtpEntryScreenState extends State<OtpEntryScreen> {
  final List<FocusNode> _focusNodes = List.generate(
    5,
        (index) => FocusNode(),
  );

  final List<TextEditingController> otpControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

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
                    ),
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
                      margin: EdgeInsets.only(
                          top: 100, left: 20, right: 20, bottom: 10),
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "Enter OTP sent on Given MailID",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Center(
                              child: Text(
                                "Discover Amazing Things Near You",
                              ),
                            ),
                          ),

                          // OTP Entry Boxes
                          _buildOtpBoxes(),

                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 36),
                            width: 320,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/ResetPass');
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Set the desired border radius here
                                  ),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                  Color(0xFFFF7F50),
                                ), // Set the button background color here
                              ),
                              child: Text(
                                'Verify OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 178),
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

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
            (index) => Container(
          width: 50.0,
          height: 50.0,
          margin: EdgeInsets.only(top: 20, right: 10, bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: otpControllers[index],
            focusNode: _focusNodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                _focusNodes[index + 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
