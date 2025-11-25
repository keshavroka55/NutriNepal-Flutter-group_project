import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'Food_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    setState((){ _loading=true; _error=null; });
    try {
      await ApiService.login(_email.text.trim(), _password.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FoodListScreen()));
    } catch (e) {
      setState(()=> _error = e.toString());
    } finally { setState(()=> _loading=false); }
  }

  @override Widget build(BuildContext ctx) => Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children:[
            TextField(controller: _email, decoration: InputDecoration(labelText:'Email')),
            TextField(controller: _password, decoration: InputDecoration(labelText:'Password'), obscureText:true),
            if (_error!=null) Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height:20),
            ElevatedButton(onPressed: _loading?null:_login, child: _loading?CircularProgressIndicator():Text('Login')),
          ])
      )
  );
}
