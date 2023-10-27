
import 'package:flutter/material.dart';

import 'package:sudent_details_database/student_list_screen.dart';
import 'database_helper.dart';
import 'main.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  var _studentNameController =TextEditingController();
  var _studentMobileNoController=TextEditingController();
  var _studentEmailIDController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(
         'Student Details Form',
         ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: _studentNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Student Name',
                    hintText: 'Enter Student Name'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentMobileNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Student MobileNo',
                      hintText: 'Enter MobileNo'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentEmailIDController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Student EmailID',
                      hintText: 'Enter EmailID'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: (){
                      print('------------> save Button Clicked');
                      _save();
                    },
                    child:Text('save'),
                ),
              ] ,
            ),
          ),
        ),
      ),
    );
  }
  void _save() async{
    print('------------> _Save');
    print('------------> Student Name : ${_studentNameController.text}');
    print('------------> Mobile No: ${_studentMobileNoController.text}');
    print('------------> Email Id : ${_studentEmailIDController.text}');

   Map<String,dynamic> row={
      DataBaseHelper.colStudentName: _studentNameController.text,
      DataBaseHelper.colMobileNo: _studentMobileNoController.text,
      DataBaseHelper.colEmailID: _studentEmailIDController.text,
    };

   final result =await dbHelper.insertStudentDetails(row,DataBaseHelper.studentDetailsTable);
   debugPrint('------------> Inserted Row Id: $result');

   if(result > 0){
     Navigator.pop(context);
     _showSuccessSnackBar(context,'Saved');
   }
   setState(() {
     Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (context)=>StudentListScreen()));
   });
  }
  void  _showSuccessSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}
















































