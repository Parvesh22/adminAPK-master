import 'package:flutter/material.dart';
import 'bargrp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/components/drawer/custom_drawer.dart';
import 'footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/StaffAttd_controller.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fk_toggle/fk_toggle.dart';
import 'graph.dart';

class StaffAttd extends StatefulWidget {
  const StaffAttd({Key? key}) : super(key: key);
  _StaffAttd createState() => _StaffAttd();
}

class _StaffAttd extends State<StaffAttd> {
  final obj = StudentAttdController();
  String token = '';
  dynamic data;

  @override
  void initState() {
    super.initState();
    getToken().then((value){
      fetchAbsentStudentData();
    });
  }

  List<ChartDataPoint> StudentGraph = [];
  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double Studenttot = prefs.getDouble('Stafftot') ?? 0.0;
    double StudentP = prefs.getDouble('StaffP') ?? 0.0;
    double StudentAB = prefs.getDouble('StaffAB') ?? 0.0;

    setState(() {
      token = prefs.getString('token') ?? '';
    });
    StudentGraph = [
      ChartDataPoint('${Studenttot.toInt()}', Studenttot, Color(0xFF6495ED)),
      ChartDataPoint('${StudentAB.toInt()}', StudentAB, Color(0xFFFF4433)),
      ChartDataPoint('${StudentP.toInt()}', StudentP, Color(0xFFFDDA0D)),
    ];
  }

  bool loader = true;
  final List<Map<String, dynamic>> tableData = [];
  void fetchAbsentStudentData() async {
    setState(() {
      tableData.clear();
    });
    Loader.show(context,
        isAppbarOverlay: true,
        overlayFromTop: 100,
        progressIndicator: CircularProgressIndicator(),
        themeData: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Color(0x99E8EAF6));
    final studentData = await obj.getAbsentStdData(token: token);
    var arr = [];
    int j = 1;
    for (var student in studentData) {
      final studentMap = {
        'no' : j,
        'Name': student.name,
        'Class': student.status,
        'Status': 'AB',
      };
      j=j+1;
      tableData.add(studentMap);
    }
    Loader.hide();
    setState(() {
      loader = false;
    });
  }

  void fetchOybStudentData() async {
    setState(() {
      tableData.clear();
    });
    Loader.show(context,
        isAppbarOverlay: true,
        overlayFromTop: 100,
        progressIndicator: CircularProgressIndicator(),
        themeData: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Color(0x99E8EAF6));
    final studentData = await obj.getPresentStdData(token: token);
    var arr = [];
    int j = 1;
    for (var student in studentData) {
      final studentMap = {
        'no' : j,
        'Name': student.name,
        'Class': student.status,
        'Status': 'PR',
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
    final OnSelected selected = ((index, instance) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Showing ${instance.labels[index]}')));

      if(instance.labels[index] == 'Present') {
        fetchOybStudentData();
      }else{
        fetchAbsentStudentData();
      }
      print('0');
    });

    final toggles = [

      FkToggle(
          width: 120,
          height: 35,
          labels: const ['Absent', 'Present'],
          selectedColor: Colors.orange,
          backgroundColor: Colors.white,
          onSelected: selected),
    ];

    double screenHeight = MediaQuery.of(context).size.height;
    double gapHeight = screenHeight * 0.65;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staff Attendance",
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
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: toggles
                        .map((e) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: e,
                    ))
                        .toList(),
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
                    child: ListView(
                      children: [
                        Container(
                          child: PieChart(
                            initialValue: 0.20,
                            data: StudentGraph,
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
                                  decoration: BoxDecoration(
                                      color: Color(0xFF6495ED),
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
                                      color: Color(0xFFFF4433),
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
                                      color: Color(0xFFFDDA0D),
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              DataTable(
                                columnSpacing: 50.0,
                                horizontalMargin:
                                0.0, // Remove horizontal margin
                                headingRowHeight:
                                30.0, // Adjust heading row height
                                dataRowHeight: 60.0,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        'S#',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Staff Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
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
                                      DataCell(Text(data['no'].toString())),
                                      DataCell(
                                          Text('${data['Name']}')),
                                      DataCell(Text(data['Status'].toString())),
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
