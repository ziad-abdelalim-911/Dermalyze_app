import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final baseUrl = 'https://dermalyze-backend-final-main-production.up.railway.app/api';

  Future<Map<String, dynamic>?> registerAndLogin(String role) async {
    final email = 'test_${role}_${DateTime.now().millisecondsSinceEpoch}@test.com';
    final pw = 'password123';

    try {
      final body = role == 'patient'
          ? {'name': 'Test $role', 'email': email, 'password': pw, 'role': role, 'doctorCode': 'TESTDOC'}
          : {'name': 'Test $role', 'email': email, 'password': pw, 'role': role};
      final regRes = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Register $role: ${regRes.statusCode} ${regRes.body}');

      final logRes = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pw}),
      );

      if (logRes.statusCode == 200) {
        return jsonDecode(logRes.body);
      } else {
        print('Login failed with status ${logRes.statusCode}: ${logRes.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  final docData = await registerAndLogin('doctor');
  final patData = await registerAndLogin('patient');

  if (docData == null || patData == null) {
    print('Login failed');
    return;
  }

  final docToken = docData['token'];
  final docId = docData['user']['_id'] ?? docData['user']['id'];

  final patToken = patData['token'];
  final patId = patData['user']['_id'] ?? patData['user']['id'];

  print('Doc ID: $docId');
  print('Pat ID: $patId');

  final headers = {'Authorization': 'Bearer $patToken'};
  final docHeaders = {'Authorization': 'Bearer $docToken'};

  // 1. Medications
  print('--- Medications ---');
  final r1 = await http.get(Uri.parse('$baseUrl/patient/$patId/medications'), headers: headers);
  print('patient/\$id/medications: \${r1.statusCode} \${r1.body}');
  
  final r2 = await http.get(Uri.parse('$baseUrl/patients/$patId/medications'), headers: headers);
  print('patients/\$id/medications: \${r2.statusCode} \${r2.body}');

  // 2. Status
  print('--- Status ---');
  final r3 = await http.put(Uri.parse('$baseUrl/patients/$patId/status'), body: jsonEncode({'status': 'Stable'}), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $docToken'});
  print('patients/\$id/status: \${r3.statusCode} \${r3.body}');
  
  final r4 = await http.put(Uri.parse('$baseUrl/doctor/patients/$patId/status'), body: jsonEncode({'status': 'Stable'}), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $docToken'});
  print('doctor/patients/\$id/status: \${r4.statusCode} \${r4.body}');

  // 3. Analysis
  print('--- Analysis ---');
  final r5 = await http.post(Uri.parse('$baseUrl/analysis/$patId'), headers: headers);
  print('analysis/\$id: \${r5.statusCode} \${r5.body}');
  
  final r6 = await http.post(Uri.parse('$baseUrl/doctor/patients/$patId/analysis'), headers: headers);
  print('doctor/patients/\$id/analysis: \${r6.statusCode} \${r6.body}');
  
  final r7 = await http.post(Uri.parse('$baseUrl/patient/$patId/analysis'), headers: headers);
  print('patient/\$id/analysis: \${r7.statusCode} \${r7.body}');
}
