import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogMealService {
  final String consumerKey = "d3b22c7be827445883972d87c42970a5";
  final String consumerSecret = "2d16afaf67de4ce79cd1ec480fc97f52";

  String? _accessToken;


  /// STEP 1 → Get Access Token
  Future<void> authenticate() async {
    print("🔵 AUTH Step Started...");
    print("🔑 KEY: $consumerKey");
    print("🔐 SECRET: $consumerSecret");
    final url = Uri.parse("https://api.logmeal.es/v2/auth/token");
    print("🌐 AUTH URL: $url");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "consumer_key": consumerKey,
        "consumer_secret": consumerSecret,
      }),
    );
    print("🟣 AUTH STATUS: ${response.statusCode}");
    print("🟣 AUTH RAW RESPONSE: ${response.body}");


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data["access_token"];
      print("🟢 ACCESS TOKEN RECEIVED: $_accessToken");
    } else {
      print(response.body);
      throw Exception("❌ AUTH FAILED → ${response.body}");
    }
  }

  /// STEP 2 → Food Recognition Endpoint
  Future<Map<String, dynamic>> recognizeFood(File image) async {
    print("⚠ TOKEN NOT FOUND — Authenticating again...");
    if (_accessToken == null) await authenticate();

    final url =
    Uri.parse("https://api.logmeal.com/v2/recognition/dish");
    print("🌐 FOOD RECOGNITION URL: $url");

    final request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = "Bearer $_accessToken";
    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception("Food recognition failed");
    }
  }

  /// STEP 3 → Barcode Scanner
  Future<Map<String, dynamic>> scanBarcode(File image) async {
    if (_accessToken == null) await authenticate();

    final url = Uri.parse("https://api.logmeal.com/v2/intake/barcode_scan");
    print("Barcode URI:$url");

    final request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = "Bearer $_accessToken";

    print("📸 SENDING BARCODE IMAGE PATH: ${image.path}");
    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    final streamed = await request.send();
    print("🟣 STREAM SENT, WAITING FOR RESPONSE...");
    final response = await http.Response.fromStream(streamed);

    print("🟣 BARCODE STATUS: ${response.statusCode}");
    print("🟣 BARCODE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception("❌ BARCODE FAILED → ${response.body}");
    }
  }
}
