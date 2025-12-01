import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/Features/logs/user_log_model.dart';
import 'package:provider/provider.dart';
import 'logs_api.dart';

class LogsHistoryScreen extends StatefulWidget {
  const LogsHistoryScreen({super.key});

  @override
  _LogsHistoryScreenState createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  List<UserLog> logs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getHistory();
  }
  Future<void> getHistory() async {
    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      final result = await logsApi.getHistory(); // List<UserLog>

      setState(() {
        logs = result;
        loading = false;
      });

    } catch (e) {
      setState(() {
        logs = [];      // empty list on error
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Logs K")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final userlog = logs[index];
          return ListTile(
            title: Text("${userlog.food} - ${userlog.quantity} ${userlog.unit}"),
            subtitle: Text(
                "${userlog.caloriesKcal} kcal | ${userlog.proteinG}g P | ${userlog.fatG}g F | ${userlog.carbsG}g C"),
            trailing: Text(userlog.timestamp.toString().split(" ")[0]),
          );
        },
      ),
    );
  }
}
