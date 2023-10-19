import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/components/drawer/custom_drawer.dart';
import 'footer.dart';
import '../controller/Home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'graph.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int selecteindex = 1;
  bool isDrawerOpen = false;
  String Image = '';
  final obj = HomeController();
  String selectedval = 'UnPublished';
  String token = '';
  double StudentAB = 0;
  double Studenttot = 0;
  double StudentP = 0;
  double StaffAB = 0;
  double Stafftot = 0;
  double StaffP = 0;

  double HMTotal = 0;
  double HMPub = 0;
  double HNUnpub = 0;

  double WKTotal = 0;
  double WKPub = 0;
  double WKunPub = 0;

  double SavedExam = 0;
  double LockedExam = 0;
  double PubExam = 0;

  String Institution = '';
  String Email = '';
  String PhoneNo = '';

  double FeePending = 0;
  double FeePaid = 0;

  String FeePeriod  = '';

  var Date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  var fromDate = DateFormat('yyyy').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    getToken().then((value) {
      fetchAbsentStudentData();
    });
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      Institution = prefs.getString('Institution') ?? '';
      PhoneNo = prefs.getString('PhoneNo') ?? '';
      Email = prefs.getString('Email') ?? '';
      Image = prefs.getString('Image') ?? '';
    });
  }

  final List<Map<String, dynamic>> tableData = [];
  List<ChartDataPoint> StudentGraph = [];
  List<ChartDataPoint> StaffGraphs = [];
  List<ChartDataPoint> HomeworkGraph = [];
  List<ChartDataPoint> WeekGraph = [];
  List<_ChartData> FeeBarGraph = [];
  List<ChartDataPoint> FeeGraph = [];
  List<ChartDataPoint> ExamGraph = [];
  bool loader = true;

  void _ShowLoggedOutBox(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Login'),
          content: Text('Session Expired! You need to login to use the app'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform logout action here
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void fetchAbsentStudentData() async {
    Loader.show(context,
        isAppbarOverlay: true,
        overlayFromTop: 100,
        progressIndicator: CircularProgressIndicator(),
        themeData: Theme.of(context).copyWith(
            colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Color(0x99E8EAF6));

    final studentData = await obj.geHomeData(token: token);
    Map<String, dynamic> parsedData = json.decode(studentData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(parsedData['message'] != 'Data Fetched.'){
      Loader.hide();
      prefs.remove('token');
      _ShowLoggedOutBox(context);
    }else {
      Map<String, dynamic> WeeklyTest = parsedData['WeeklyTestData'];
      Map<String, dynamic> StaffAttendance = parsedData['StaffAttendance'];
      Map<String, dynamic> StdAttendance = parsedData['StudentAttendance'];
      Map<String, dynamic> Homework = parsedData['Homework'];
      Map<String, dynamic> FeeData = parsedData['FeeData'];
      Map<String, dynamic> Exam = parsedData['Exam'];
      List classWiseFee = parsedData['ClassWiseFee'];
      for (var feeItem in classWiseFee) {
        String classSection = feeItem['ClassSection'];
        double pendingAmount = double.parse(feeItem['PendingAmount']);
        double netPayableAmount = double.parse(feeItem['NetPayableAmount']);
        String FeePeriods = feeItem['FeePeriod'];
        setState(() {
          FeePeriod = FeePeriods;
        });
        FeeBarGraph.add(_ChartData(classSection, pendingAmount, netPayableAmount));
      }
      setState(() {
        Studenttot = StdAttendance['Total'].toDouble();
        prefs.setDouble('Studenttot', Studenttot);
        StudentAB = StdAttendance['Absent'].toDouble();
        prefs.setDouble('StudentAB', StudentAB);
        StudentP = StdAttendance['Present'].toDouble();
        prefs.setDouble('StudentP', StudentP);

        Stafftot = StaffAttendance['Total'].toDouble();
        prefs.setDouble('Stafftot', Stafftot);
        StaffAB = StaffAttendance['Absent'].toDouble();
        prefs.setDouble('StaffAB', StaffAB);
        StaffP = StaffAttendance['Present'].toDouble();
        prefs.setDouble('StaffP', StaffP);

        SavedExam = Exam['Save'].toDouble();
        prefs.setDouble('SavedExam', SavedExam);
        LockedExam = Exam['Locked'].toDouble();
        prefs.setDouble('LockedExam', LockedExam);
        PubExam = Exam['Published'].toDouble();
        prefs.setDouble('PubExam', PubExam);


        HMTotal = Homework['Total'].toDouble();
        HMPub = Homework['Published'].toDouble();
        prefs.setDouble('HMPub', HMPub);
        HNUnpub = Homework['UnPublished'].toDouble();
        prefs.setDouble('HNUnpub', HNUnpub);

        WKTotal = WeeklyTest['Save'].toDouble();
        prefs.setDouble('WKTotal', WKTotal);
        WKPub = WeeklyTest['Published'].toDouble();
        prefs.setDouble('WKPub', WKPub);
        WKunPub = WeeklyTest['UnPublished'].toDouble();
        prefs.setDouble('WKunPub', WKunPub);

        FeePaid = FeeData['Paid'].toDouble();
        prefs.setDouble('FeePaid', FeePaid);
        FeePending = FeeData['Pending'].toDouble();
        prefs.setDouble('FeePending', FeePending);

        FeeGraph = [
          ChartDataPoint('${FeePaid.toInt()}', FeePaid, Color(0xFF6495ED)),
          ChartDataPoint('${FeePending.toInt()}', FeePending, Color(0xFFFF4433)),
        ];

        ExamGraph = [
          ChartDataPoint('${LockedExam.toInt()}', LockedExam, Color(0xFF6495ED)),
          ChartDataPoint('${SavedExam.toInt()}', SavedExam, Color(0xFFFF4433)),
          ChartDataPoint('${PubExam.toInt()}', PubExam, Color(0xFFFDDA0D)),
        ];


        StudentGraph = [
          ChartDataPoint('${Studenttot.toInt()}', Studenttot, Color(0xFFFFA500)),
          ChartDataPoint('${StudentAB.toInt()}', StudentAB, Color(0xFFFF0000)),
          ChartDataPoint('${StudentP.toInt()}', StudentP, Color(0xFF00FF00)),
        ];

        StaffGraphs = [
          ChartDataPoint('${Stafftot.toInt()}', Stafftot, Color(0xFFFFA500)),
          ChartDataPoint('${StaffAB.toInt()}', StaffAB, Color(0xFFFF0000)),
          ChartDataPoint('${StaffP.toInt()}', StaffP, Color(0xFF00FF00)),
        ];

        HomeworkGraph = [
          ChartDataPoint('${HMPub.toInt()}', HMPub, Color(0xFFFDDA0D)),
          ChartDataPoint('${HNUnpub.toInt()}', HNUnpub, Color(0xFFFF4433)),
        ];

        WeekGraph = [
          ChartDataPoint('${WKPub.toInt()}', WKPub, Color(0xFFFDDA0D)),
          ChartDataPoint('${WKunPub.toInt()}', WKunPub, Color(0xFFFF4433)),
          ChartDataPoint('${WKTotal.toInt()}', WKTotal, Color(0xFF6495ED)),
        ];

        loader = false;
      });
    }
    Loader.hide();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the gapHeight based on screen size
    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.30;
    double gapHeights = screenHeight * 0.65;
    double emptyboxHeights = screenHeight * 0.25;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
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
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(
                            3.0), // Adjust the padding for the border
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // Border color
                        ),
                        child: CircleAvatar(
                          radius: 32.0,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(
                            '${Image}',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  "${Institution}",
                                  style: TextStyle(
                                      color: Color(0xFFff753a),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 6),
                              child: Text(
                                "${Email}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 6),
                            child: Text(
                              "${PhoneNo}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: gapHeights,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  margin: EdgeInsets.only(left: 4, right: 4),
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 200,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Students Attendance (${Date})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Studenttot+StudentAB+StudentP == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: StudentGraph,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFFA500),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Center(
                                              child: Text("Leave",style: TextStyle(color: Colors.white, fontSize: 12,),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 10, right:10),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF0000),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Absent",style: TextStyle(color: Colors.white, fontSize: 12,),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF00FF00),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Present",style: TextStyle(color: Colors.white, fontSize: 12,),),
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
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 12),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Homework (${Date})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              HMTotal+HMPub+HNUnpub == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: HomeworkGraph,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF4433),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Unpublished",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFDDA0D),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Published",style: TextStyle(color: Colors.white, fontSize: 12),),
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
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Staff Attendance (${Date})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Stafftot+StaffP+StaffAB == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: StaffGraphs,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFFA500),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Center(
                                              child: Text("Leave",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF0000),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Absent",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF00FF00),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Present",style: TextStyle(color: Colors.white,  fontSize: 12),),
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
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 12),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Weekly Test (${Date})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              WKTotal+WKunPub+WKPub == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: WeekGraph,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20, right: 10, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6495ED),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Saved",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF4433),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Unpublished",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFDDA0D),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Published",style: TextStyle(color: Colors.white, fontSize: 12),),
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
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Exam Report (Latest Exam)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SavedExam+PubExam+LockedExam == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: ExamGraph,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6495ED),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Center(
                                              child: Text("Locked",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF4433),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Saved",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFDDA0D),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Published",style: TextStyle(color: Colors.white,  fontSize: 12),),
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
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Class Wise Fee of ${FeePeriod}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: _PageGraph(data: FeeBarGraph)
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFff753a),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Pending",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFDDA0D),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Paid",style: TextStyle(color: Colors.white,  fontSize: 12),),
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
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius as needed
                          ),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 12),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Fee Status (01/04/${fromDate} to ${Date})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              FeePending+FeePaid == 0 ?
                              Container(
                                height: emptyboxHeights ,
                                child: Center(
                                  child: Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              )
                                  :
                              Column(
                                children: [
                                  Container(
                                    child: PieChart(
                                      initialValue: 0.25,
                                      data: FeeGraph,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(left: 3, right:3),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF4433),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Pending",style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6495ED),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text("Paid",style: TextStyle(color: Colors.white, fontSize: 12),),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}


class _PageGraph extends StatefulWidget {
  late List<_ChartData> data;

  _PageGraph({Key? key, required this.data}) : super(key: key);

  @override
  PageGraph createState() => PageGraph();
}

class PageGraph extends State<_PageGraph> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum value for the Y-axis dynamically
    double maxPaid = widget.data.map((data) => data.y1).reduce((a, b) => a > b ? a : b);
    double maxPending = widget.data.map((data) => data.y2).reduce((a, b) => a > b ? a : b);
    double maxYValue = maxPaid > maxPending ? maxPaid : maxPending;

    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.24;

    return Container(
      height: gapHeight,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: maxYValue, // Set the maximum value dynamically
          interval: maxYValue / 10, // Set the interval dynamically
          numberFormat: NumberFormat.compact(), // Use compact number format
        ),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
            dataSource: widget.data,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y1,
            name: 'Pending', // Name for the first bar
            color: Color(0xFFff753a),
            width: 0.3, // Adjust the width of the bars to create space
          ),
          ColumnSeries<_ChartData, String>(
            dataSource: widget.data,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y2,
            name: 'Paid', // Name for the second bar
            color: Color(0xFFFDDA0D),
            width: 0.3, // Adjust the width of the bars to create space
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y1, this.y2);

  final String x;
  final double y1;
  final double y2;
}
