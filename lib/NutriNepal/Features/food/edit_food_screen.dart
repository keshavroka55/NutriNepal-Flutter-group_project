import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../API/api_client.dart';
import '../logs/logs_api.dart';
import 'food_model.dart';

class EditFoodScreen extends StatefulWidget {
  final Food food;
  const EditFoodScreen({super.key, required this.food});

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  double quantity = 100;
  bool saving = false;

  Future<void> saveLog() async {
    setState(() => saving = true);
    // after changing the login to provide the token
    final logsApi = Provider.of<LogsApi>(context, listen: false);
    // Debug: check if token is set
    debugPrint('Token being sent: ${logsApi.apiClient.token}');
    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      // DEBUG: print token before calling
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      debugPrint('Calling addLog with token: ${apiClient.token}');
      debugPrint('Sending payload: foodId=${widget.food.id}, quantity=$quantity, unit=${widget.food.unit}');

      await logsApi.addLog(
          foodId: widget.food.id,
          quantity: quantity,
          unit: widget.food.unit);
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food added to log")));
      Navigator.pop(context);
    }catch (e, st) {
      debugPrint('addLog error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add log: $e')));
    }finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit ${widget.food.nameEn}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("${widget.food.caloriesKcal} kcal per ${widget.food.servingSize}"), // somethings is confusion so, need to change to unit.
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Quantity (${widget.food.servingSize})",
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => quantity = double.tryParse(val) ?? 100,
            ),
            const SizedBox(height: 20),
            saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: saveLog,
              child: const Text("Add to Log"),
            ),
          ],
        ),
      ),
    );
  }
}
