import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/widgets/bottom_control_panel.dart';
import 'logs/logs_api.dart';
import 'logs/user_log_model.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logsApi = Provider.of<LogsApi>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Daily Logs")),
      body: LogsHistoryWidget(logsApi: logsApi), // Only shows daily logs
    );
  }
}

// Widget to show logs history
class LogsHistoryWidget extends StatefulWidget {
  final LogsApi logsApi;
  const LogsHistoryWidget({super.key, required this.logsApi});

  @override
  _LogsHistoryWidgetState createState() => _LogsHistoryWidgetState();
}

class _LogsHistoryWidgetState extends State<LogsHistoryWidget> {
  List<UserLog> logs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() => loading = true); // spinner starts

    try {
      final result = await widget.logsApi.getHistory(); // List<UserLog>
      setState(() {
        logs = result;
      });
    } catch (e) {
      setState(() {
        logs = []; // empty list on error
      });

      // Optional: show error in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load logs: $e')),
      );
    } finally {
      setState(() => loading = false); // spinner stops
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (logs.isEmpty) return const Center(child: Text("No logs found today"));

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text("${log.food?.nameEn} - ${log.quantity} ${log.unit}"),
            subtitle: Text(
                "${log.food?.caloriesKcal} kcal | ${log.food!.proteinG}g P | ${log.food!.fatG}g F | ${log.food!.carbsG}g C"),
            trailing: Text(log.timestamp.toString().split(" ")[0]),
          ),
        );
      },
    );
  }
}
