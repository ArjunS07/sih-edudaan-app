import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:sih_app/models/Account.dart';
import 'package:sih_app/models/School.dart';
import 'package:sih_app/models/Student.dart';

final String ROOT_URL = 'http://localhost:8000';
final uuid = Uuid();

Future<Account?> createAccount(
    String email, String password, String firstName, String lastName) async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final registerUri = Uri.parse('$ROOT_URL/accounts/register/');
  var request = http.Request('POST', registerUri);
  request.bodyFields = {
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName
  };
  request.headers.addAll(headers);
  print(request);
  print(request.bodyFields);
  print(request.headers);

  http.StreamedResponse response = await request.send();
  Map<String, dynamic> body =
      json.decode(await response.stream.bytesToString());

  if (response.statusCode == 201) {
    return Account.fromJson(body);
  } else {
    print(response.reasonPhrase);
    throw Exception(body);
  }
}

Future<Student?> createStudent(Account account, String city,
    List<String> languages, School school, String board, String grade) async {
  // 1. Make an API call to create a student account
  final String parsedLanguages = languages.join(',');
  final String studentUuid = uuid.v4();

  final Uri studentCreationUri = Uri.parse('$ROOT_URL/api/student');
  var studentCreationHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  var studentCreationRequest = http.Request('POST', studentCreationUri);
  studentCreationRequest.bodyFields = {
    'account__id': account.accountId.toString(),
    'city': city,
    'languages': parsedLanguages,
    'board': board,
    'grade': grade,
    'uuid': studentUuid
  };
  studentCreationRequest.headers.addAll(studentCreationHeaders);
  print(studentCreationRequest.bodyFields);
  print(studentCreationRequest.headers);

  http.StreamedResponse studentCreationResponse =
      await studentCreationRequest.send();
  Map<String, dynamic> studentCreationBody =
      json.decode(await studentCreationResponse.stream.bytesToString());

  if (studentCreationResponse.statusCode != 201) {
    print(studentCreationResponse.reasonPhrase);
    throw Exception(studentCreationBody);
  }

  // 2. Make the student join the school
  final Uri joinSchoolUri = Uri.parse('$ROOT_URL/api/joinschool');
  var joinSchoolRequest = http.Request('POST', joinSchoolUri);

  var joinSchoolheaders = {'Content-Type': 'application/x-www-form-urlencoded'};
  joinSchoolRequest.bodyFields = {
    'join_code': school.joinCode,
    'student_uuid': studentUuid
  };

  http.StreamedResponse joinSchoolResponse = await joinSchoolRequest.send();
  Map<String, dynamic> joinSchoolBody = json.decode(await joinSchoolResponse.stream.bytesToString());

  if (joinSchoolResponse.statusCode != 200) {
    print(joinSchoolResponse.reasonPhrase);
    print(joinSchoolResponse.reasonPhrase);
    print(joinSchoolBody);
    throw Exception(joinSchoolBody);
  }

  print('Joined student to school');

  Student student = Student(
      account: account,
      city: city,
      languages: languages,
      school: school,
      board: board,
      grade: grade,
      uuid: studentUuid);

  return student;
}
