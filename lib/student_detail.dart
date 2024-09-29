// student_detail.dart
import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final String? studentId;

  const StudentDetailScreen({super.key, this.studentId});

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late bool isEditing;
  Student? student;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  String year = 'First Year';
  bool enrolled = false;

  @override
  void initState() {
    super.initState();
    isEditing = widget.studentId != null;
    if (isEditing) {
      apiService.getStudentById(widget.studentId!).then((value) {
        setState(() {
          student = value;
          firstNameController.text = student!.firstName;
          lastNameController.text = student!.lastName;
          courseController.text = student!.course;
          year = student!.year;
          enrolled = student!.enrolled;
        });
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  void saveStudent() async {
    if (_formKey.currentState!.validate()) {
      Student newStudent = Student(
        id: student?.id ?? '',
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        course: courseController.text,
        year: year,
        enrolled: enrolled,
      );
      if (isEditing) {
        await apiService.updateStudent(newStudent);
      } else {
        await apiService.createStudent(newStudent);
      }
      Navigator.pop(context);
    }
  }

  void deleteStudent() async {
    await apiService.deleteStudent(student!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing && student == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // First Name
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter first name' : null,
              ),
              // Last Name
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              // Course
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) => value!.isEmpty ? 'Enter course' : null,
              ),
              // Year Dropdown
              DropdownButtonFormField<String>(
                value: year,
                items: [
                  'First Year',
                  'Second Year',
                  'Third Year',
                  'Fourth Year',
                  'Fifth Year'
                ]
                    .map((label) =>
                        DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    year = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              // Enrolled Switch
              SwitchListTile(
                title: const Text('Enrolled'),
                value: enrolled,
                onChanged: (bool value) {
                  setState(() {
                    enrolled = value;
                  });
                },
              ),
              // Save Button
              ElevatedButton(
                onPressed: saveStudent,
                child: Text(isEditing ? 'Update' : 'Save'),
              ),
              // Delete Button (only in edit mode)
              if (isEditing)
                ElevatedButton(
                  onPressed: deleteStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
