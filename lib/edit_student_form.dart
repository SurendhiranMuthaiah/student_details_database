
import 'package:flutter/material.dart';
import 'package:sudent_details_database/student_details_model.dart';
import 'package:sudent_details_database/student_list_screen.dart';

import 'database_helper.dart';
import 'main.dart';

class EditStudentFormScreen extends StatefulWidget {
  const EditStudentFormScreen({super.key});

  @override
  State<EditStudentFormScreen> createState() => _EditStudentFormScreenState();
}

class _EditStudentFormScreenState extends State<EditStudentFormScreen> {
  var _studentNameController =TextEditingController();
  var _studentMobileNoController=TextEditingController();
  var _studentEmailIDController=TextEditingController();

  bool firstTimeFlag=false;
  int _selectedId=0;

  @override
  Widget build(BuildContext context) {

    if(firstTimeFlag==false) {
      print('----------->once execute');


      firstTimeFlag = true;

      final studentDetails = ModalRoute
          .of(context)!
          .settings
          .arguments as StudentDetailsModel;

      print('-------------->Received Data');
      print(studentDetails.id);
      print(studentDetails.studentName);
      print(studentDetails.studentMobileNo);
      print(studentDetails.studentEmailId);

      _selectedId = studentDetails.id!;

      _studentNameController.text = studentDetails.studentName;
      _studentMobileNoController.text = studentDetails.studentMobileNo;
      _studentEmailIDController.text = studentDetails.studentEmailId;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Details Form',
        ),
        actions: [
          PopupMenuButton(
              itemBuilder:(context) => [
                PopupMenuItem(value: 1,child: Text("Delete")),
              ],
            elevation: 2,
            onSelected: (value){
                if(value == 1){
                  print('Delete option clicked');
                }
            },
          ),
        ],
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
                      labelText: 'Student EmailId',
                      hintText: 'Enter EmailId'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: (){
                    print('------------> Updated Button Clicked');
                    _update();
                  },
                  child:Text('Updated'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _deleteFormDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param){
          return AlertDialog(
            actions:<Widget> [
            ElevatedButton(
                onPressed:(){
                  print('----------->Cancel Button Clicked');
                  Navigator.pop(context);
          },
                child: const Text('Cancel'),
            ),
              ElevatedButton(
                  onPressed: () async{
                    print('-------->Delete Button Clicked');
                    _delete();
          },
                  child: const Text('Delete'),
          ),
            ],
          );
        }
    );
  }

  void _update() async{
    print('------------> _Updated');

    print('--------------->Selected ID: $_selectedId');
    print('------------> StudentName : ${_studentNameController.text}');
    print('------------> MobileNo: ${_studentMobileNoController.text}');
    print('------------> EmailId : ${_studentEmailIDController.text}');

    Map<String,dynamic> row={

      DataBaseHelper.colId: _selectedId,

      DataBaseHelper.colStudentName: _studentNameController.text,
      DataBaseHelper.colMobileNo: _studentMobileNoController.text,
      DataBaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result =await dbHelper.updateStudentDetails(row,DataBaseHelper.studentDetailsTable);
    debugPrint('------------> Updated Row Id: $result');

    if(result > 0){
      Navigator.pop(context);
      _showSuccessSnackBar(context,'Updated');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=>StudentListScreen()));
    });
  }
  void  _showSuccessSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async
  {
    print('---------> _delete');

    final result =await dbHelper.deleteStudentDetails(_selectedId,DataBaseHelper.studentDetailsTable);

    debugPrint('------->Delete Row Id: $result');

    if(result > 0){
      _showSuccessSnackBar(context,'Delete.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentListScreen()));
    });
  }
}































































