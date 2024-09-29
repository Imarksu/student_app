// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  final String apiUrl = 'http://10.0.2.2:3000/students';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(apiUrl));
    Iterable list = json.decode(response.body);
    return list.map((student) => Student.fromJson(student)).toList();
  }

  Future<Student> getStudentById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    return Student.fromJson(json.decode(response.body));
  }

  Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    return Student.fromJson(json.decode(response.body));
  }

  Future<Student> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${student.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    return Student.fromJson(json.decode(response.body));
  }

  Future<void> deleteStudent(String id) async {
    await http.delete(Uri.parse('$apiUrl/$id'));
  }
}
