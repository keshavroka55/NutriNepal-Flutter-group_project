import 'package:flutter/material.dart';
import '../models/user_log.dart';
import '../services/api_service.dart';
import '../widgets/bottom_control_panel.dart';

class LogsScreen extends StatefulWidget {
  @override State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<UserLog> _logs = [];
  bool _loading = true;

  @override void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(()=>_loading=true);
    try {
      _logs = await ApiService.getLogs();
    } catch (e) {}
    setState(()=>_loading=false);
  }

  @override Widget build(BuildContext ctx) => Scaffold(
      appBar: AppBar(title: Text('My Logs')),
      body: _loading ? Center(child:CircularProgressIndicator()) :
      ListView.separated(
          itemCount: _logs.length,
          separatorBuilder: (_,__)=>Divider(),
          itemBuilder: (_,i){
            final l = _logs[i];
            return ListTile(
              title: Text('${l.food.nameEn} — ${l.quantity}${l.unit}'),
              subtitle: Text('${l.calories ?? (l.food.calories * (l.quantity / l.food.servingSize))} kcal'),
              trailing: Text('${l.timestamp.toLocal().toString().split(' ')[0]}'),
            );
          }
      ),
      bottomNavigationBar:
      const BottomControlPanel(currentIndex: 0),
  );
}
