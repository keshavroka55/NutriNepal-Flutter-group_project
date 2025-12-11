import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// used while testing the points of node.js backend that the data is not featching
// caused that the token is not passed successfully.
class ApiDebugScreen extends StatefulWidget {
  @override
  _ApiDebugScreenState createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  final String baseUrl = "https://nutrinepal-node-api.onrender.com";
  String token = "";

  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    // Load token from SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('token') ?? '';
  }

  Future<void> testEndpoint(String name, String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        results.add({
          'name': name,
          'endpoint': endpoint,
          'status': response.statusCode,
          'success': response.statusCode == 200,
        });
      });

      print("$name ($endpoint): ${response.statusCode}");
    } catch (e) {
      setState(() {
        results.add({
          'name': name,
          'endpoint': endpoint,
          'status': 0,
          'success': false,
          'error': e.toString(),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Endpoint Debug")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() => results.clear());
              testEndpoint("Profile", "$baseUrl/api/v1/user/profile");
              testEndpoint("Logs History", "$baseUrl/api/logs/history");
              testEndpoint("Foods", "$baseUrl/api/foods");
              },
            child: Text("Test All Endpoints"),
          ),
          SizedBox(height: 20),
          ...results.map((result) => Card(
            color: result['success'] ? Colors.green[50] : Colors.red[50],
            child: ListTile(
              leading: Icon(
                result['success'] ? Icons.check_circle : Icons.error,
                color: result['success'] ? Colors.green : Colors.red,
              ),
              title: Text(result['name']),
              subtitle: Text(result['endpoint']),
              trailing: Text("${result['status']}"),
            ),
          )).toList(),
        ],
      ),
    );
  }
}