import 'package:flutter/material.dart';
import 'bargrp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/components/drawer/custom_drawer.dart';
import 'footer.dart';
import '../controller/fee_report_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fk_toggle/fk_toggle.dart';
import 'graph.dart';

class FeeReport extends StatefulWidget {
  const FeeReport({Key? key}) : super(key: key);
  _FeeReport createState() => _FeeReport();
}

class _FeeReport extends State<FeeReport> {
  final obj = ExamController();
  String selectedval = 'Unpublished';
  String token = '';
  @override
  void initState() {
    super.initState();
    getToken().then((value){
      fetchAbsentStudentData();
    });
    print('1');
  }

  List<ChartDataPoint> FeeGraph = [];
  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double FeePaid = prefs.getDouble('FeePaid') ?? 0.0;
    double FeePending = prefs.getDouble('FeePending') ?? 0.0;
    setState(() {
      token = prefs.getString('token') ?? '';
    });
    FeeGraph = [
      ChartDataPoint('${FeePaid.toInt()}', FeePaid, Color(0xFFFDDA0D)),
      ChartDataPoint('${FeePending.toInt()}', FeePending, Color(0xFFFF4433)),
    ];
  }

  List<Map<String, dynamic>> tableData = [];
  bool loader = true;
  void fetchAbsentStudentData() async {
    setState(() {
      tableData.clear();
    });
    final obja = ExamController();
    Loader.show(context,
        isAppbarOverlay: true,
        overlayFromTop: 100,
        progressIndicator: CircularProgressIndicator(),
        themeData: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Color(0x99E8EAF6));
    final studentData = await obja.getExamData(token: token, type: 'Save');
    print(studentData);
    var arr = [];
    int j = 1;
    for (var student in studentData) {
      final studentMap = {
        'no' : j,
        'ClassSection': student.ClassSection,
        'PendingAmt': student.PendingAmt,
        'PendingStd' : student.PendingStd,
        'TotalStd' : student.TotalStd
      };
      j=j+1;
      tableData.add(studentMap);
    }
    Loader.hide();
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.73;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fee Report",
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
                    child: ListView(
                      children: [
                        Container(
                          child: PieChart(
                            initialValue: 0.20,
                            data: FeeGraph,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.only(left: 10, right:10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFF4433),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Text("Pending",style: TextStyle(color: Colors.white, fontSize: 12,),),
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
                                    child: Text("Paid",style: TextStyle(color: Colors.white, fontSize: 12,),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              DataTable(
                                columnSpacing: 15.0,
                                horizontalMargin:
                                1.0, // Remove horizontal margin
                                headingRowHeight:
                                30.0, // Adjust heading row height
                                dataRowHeight: 60.0,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        'Class',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Pend. Amt.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Pend. Std.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tot. Std.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: tableData.map((data) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(data['ClassSection'].toString())),
                                      DataCell(Text('${data['PendingAmt']}')),
                                      DataCell(Text('      ${data['PendingStd']}')),
                                      DataCell(
                                          Text('     ${data['TotalStd']}')),
                                    ],
                                  );
                                }).toList(),
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
