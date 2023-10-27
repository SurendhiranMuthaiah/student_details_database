import 'package:flutter/material.dart';
import 'package:sudent_details_database/student_details_model.dart';
import 'package:sudent_details_database/student_list_screen.dart';

import 'database_helper.dart';
import 'main.dart';

class OptimizeStudentFormScreen extends StatefulWidget {
  const OptimizeStudentFormScreen({super.key});

  @override
  State<OptimizeStudentFormScreen> createState() =>
      _OptimizeStudentFormScreenState();
}

class _OptimizeStudentFormScreenState extends State<OptimizeStudentFormScreen> {
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIDController = TextEditingController();

  bool firstTimeFlag = false;
  int _selectedId = 0;

  String buttonText = 'save';

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('----------->once execute');

      firstTimeFlag = true;

      final studentDetails = ModalRoute.of(context)!.settings.arguments;

      if (studentDetails == null) {
        print('------->FAB: Insert/Save: ');
      } else {
        print('------------>ListView: Received Data: Edit/Delete');

        studentDetails as StudentDetailsModel;

        print('-------------->Received Data');
        print(studentDetails.id);
        print(studentDetails.studentName);
        print(studentDetails.studentMobileNo);
        print(studentDetails.studentEmailId);

        _selectedId = studentDetails.id!;
        buttonText = 'Update';

        _studentNameController.text = studentDetails.studentName;
        _studentMobileNoController.text = studentDetails.studentMobileNo;
        _studentEmailIDController.text = studentDetails.studentEmailId;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Details Form',
        ),
        actions: _selectedId != 0
            ? [
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text("Delete")),
                  ],
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      _deleteFormDialog(context);
                    }
                  },
                ),
              ]
            : null,
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
                      hintText: 'Enter Student Name'),
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
                      hintText: 'Enter MobileNo'),
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
                      hintText: 'Enter EmailId'),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('------------> Button Clicked');
                    if (_selectedId == 0) {
                      print('---------->Save');
                      _save();
                    } else {
                      print('-----------> Update');
                      _update();
                    }
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('-----------> Cancel Button Clicked');
                  Navigator.pop((context));
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('-------->Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              ),
            ],
            title: const Text('Are you sure you want to delete this ?'),
          );
        });
  }

  void _save() async {
    print('------------> _save');

    print('------------> StudentName : ${_studentNameController.text}');
    print('------------> MobileNo: ${_studentMobileNoController.text}');
    print('------------> EmailId : ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {
      DataBaseHelper.colStudentName: _studentNameController.text,
      DataBaseHelper.colMobileNo: _studentMobileNoController.text,
      DataBaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.insertStudentDetails(
        row, DataBaseHelper.studentDetailsTable);
    debugPrint('------------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'saved');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentListScreen()));
    });
  }

  void _update() async {
    print('------------> _update');

    print('--------------->Selected ID: $_selectedId');
    print('------------> StudentName : ${_studentNameController.text}');
    print('------------> MobileNo: ${_studentMobileNoController.text}');
    print('------------> EmailId : ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {
      DataBaseHelper.colId: _selectedId,
      DataBaseHelper.colStudentName: _studentNameController.text,
      DataBaseHelper.colMobileNo: _studentMobileNoController.text,
      DataBaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.updateStudentDetails(
        row, DataBaseHelper.studentDetailsTable);
    debugPrint('------------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async {
    print('---------> _delete');

    final result = await dbHelper.deleteStudentDetails(
        _selectedId, DataBaseHelper.studentDetailsTable);

    debugPrint('------->Delete Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Delete.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentListScreen()));
    });
  }
}
