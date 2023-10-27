import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sudent_details_database/edit_student_form.dart';
import 'package:sudent_details_database/optimize_student_form.dart';

import 'package:sudent_details_database/student_details_model.dart';
import 'package:sudent_details_database/student_form_screen.dart';
import 'main.dart';
import 'database_helper.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

  late List<StudentDetailsModel> _studentDetailsList= <StudentDetailsModel>[];

  @override
  void initState() {
    super.initState();
    getAllStudentDetails();
  }

  getAllStudentDetails() async {
    //_studentDetailsList = <StudentDetailsModel>[];

    var studentDetailsRecords =
        await dbHelper.queryAllRows(DataBaseHelper.studentDetailsTable);

    studentDetailsRecords.forEach((studentDetails) {

      setState(() {
        print(studentDetails['_id']);
        print(studentDetails['_studentName']);
        print(studentDetails['_mobileNo']);
        print(studentDetails['_emailId']);

        var studentDetailsModel = StudentDetailsModel(
          studentDetails['_id'],
          studentDetails['_studentName'],
          studentDetails['_mobileNo'],
          studentDetails['_emailId'],
        );

        _studentDetailsList.add(studentDetailsModel);
      });
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Details',
        ),
      ),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _studentDetailsList.length,
              itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap: (){
                   print('------------>Edit or Delete invoke : Send Data ');
                   print(_studentDetailsList[index].id);
                   print(_studentDetailsList[index].studentName);
                   print(_studentDetailsList[index].studentMobileNo);
                   print(_studentDetailsList[index].studentEmailId);

                   Navigator.of(context).push(MaterialPageRoute(
                       builder: (context)=>OptimizeStudentFormScreen(),
                     settings: RouteSettings(
                       arguments: _studentDetailsList[index],
                     ),
                   ));

                },
                child: ListTile(
                  title: Text(_studentDetailsList[index].studentMobileNo),
                ),
              );
              },
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('------------->Lanch Student Form Screen');
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OptimizeStudentFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
