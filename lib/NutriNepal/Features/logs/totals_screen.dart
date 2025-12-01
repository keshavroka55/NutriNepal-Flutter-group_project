import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'logs_api.dart';
import 'totals_model.dart'; // import your Totals model

class TotalsScreen extends StatefulWidget {
  const TotalsScreen({super.key});

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  Totals? totals;  // use Totals object
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTotals();
  }

  Future<void> fetchTotals() async {
    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      final result = await logsApi.getTotals(); // returns Totals

      setState(() {
        totals = result;   // assign Totals object
        loading = false;
      });
    } catch (e) {
      setState(() {
        totals = null;     // error → set to null
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Totals")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : totals == null
          ? const Center(child: Text("Failed to load totals"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Calories: ${totals!.caloriesKcal} kcal"),
            Text("Protein: ${totals!.proteinG} g"),
            Text("Fat: ${totals!.fatG} g"),
            Text("Carbs: ${totals!.carbsG} g"),
          ],
        ),
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 1),
    );
  }
}
