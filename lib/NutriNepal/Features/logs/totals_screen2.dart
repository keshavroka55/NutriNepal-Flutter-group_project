import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'logs_api.dart';
import 'totals_model.dart';

class TotalsScreen2 extends StatefulWidget {
  const TotalsScreen2({super.key});

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen2> {
  List<Totals> dailyTotals = []; // List for multiple days
  bool loading = true;
  DateTime selectedDate = DateTime.now();
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    // Default: Get last 7 days
    final now = DateTime.now();
    fromDate = now.subtract(const Duration(days: 7));
    toDate = now;
    fetchDailyTotals();
  }

  Future<void> fetchDailyTotals() async {
    setState(() => loading = true);

    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);

      // If you want multiple days, you might need to call API multiple times
      // or modify your backend to return multiple days at once
      // For now, let's assume you can get totals for a date range
      final result = await logsApi.getTotals(
        from: fromDate?.toIso8601String().split('T')[0],
        to: toDate?.toIso8601String().split('T')[0],
      );

      setState(() {
        // Since getTotals returns a single Totals object for a range,
        // we need to handle it differently
        dailyTotals = [result]; // Just add this single result
        loading = false;
      });
    } catch (e) {
      setState(() {
        dailyTotals = [];
        loading = false;
      });
    }
  }

  // Mock data for demonstration - you should get this from user profile
  final Map<String, double> dailyGoals = {
    'calories': 2000.0,
    'protein': 50.0,
    'fat': 65.0,
    'carbs': 300.0,
  };

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: NutriColors.textPrimary,
        elevation: 0,
        title: const Text(
          "Daily Progress",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchDailyTotals,
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: NutriColors.primary),
      )
          : dailyTotals.isEmpty
          ? _buildEmptyState()
          : _buildDailyProgressList(),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Get totals for selected date
        fetchTotalsForDate(picked);
      });
    }
  }

  Future<void> fetchTotalsForDate(DateTime date) async {
    setState(() => loading = true);

    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      final result = await logsApi.getTotals(
        date: date.toIso8601String().split('T')[0],
      );

      setState(() {
        dailyTotals = [result];
        loading = false;
      });
    } catch (e) {
      setState(() {
        dailyTotals = [];
        loading = false;
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: NutriColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No Data Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: NutriColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'No nutrition data available for the selected date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: NutriColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => fetchDailyTotals(),
            style: ElevatedButton.styleFrom(
              backgroundColor: NutriColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgressList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date Range Selector
        _buildDateRangeSelector(),
        const SizedBox(height: 20),

        // Daily Progress Cards
        ...dailyTotals.map((dayTotal) => _buildDailyCard(dayTotal)).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NutriColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fetchTotalsForDate(DateTime.now()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriColors.primary.withOpacity(0.1),
                    foregroundColor: NutriColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reduced padding
                    minimumSize: const Size(0, 40), // Fixed minimum height
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Today'),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Reduced from 0 to 8 (or remove for no gap)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final yesterday = DateTime.now().subtract(const Duration(days: 1));
                    fetchTotalsForDate(yesterday);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriColors.primary.withOpacity(0.1),
                    foregroundColor: NutriColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Yesterday'),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Reduced gap
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDatePicker(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Pick Date'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(Totals dayTotal) {
    final percentageCalories = (dayTotal.caloriesKcal / dailyGoals['calories']!).clamp(0.0, 1.0);
    final percentageProtein = (dayTotal.proteinG / dailyGoals['protein']!).clamp(0.0, 1.0);
    final percentageFat = (dayTotal.fatG / dailyGoals['fat']!).clamp(0.0, 1.0);
    final percentageCarbs = (dayTotal.carbsG / dailyGoals['carbs']!).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NutriColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(dayTotal.date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.textPrimary,
                  ),
                ),
                Text(
                  '${dayTotal.count} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: NutriColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Progress Bars
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildNutrientProgressBar(
                  label: 'Calories',
                  value: dayTotal.caloriesKcal,
                  goal: dailyGoals['calories']!,
                  percentage: percentageCalories,
                  unit: 'Cal',
                  color: NutriColors.accent,
                ),
                const SizedBox(height: 12),
                _buildNutrientProgressBar(
                  label: 'Protein',
                  value: dayTotal.proteinG,
                  goal: dailyGoals['protein']!,
                  percentage: percentageProtein,
                  unit: 'g',
                  color: NutriColors.success,
                ),
                const SizedBox(height: 12),
                _buildNutrientProgressBar(
                  label: 'Fat',
                  value: dayTotal.fatG,
                  goal: dailyGoals['fat']!,
                  percentage: percentageFat,
                  unit: 'g',
                  color: NutriColors.danger,
                ),
                const SizedBox(height: 12),
                _buildNutrientProgressBar(
                  label: 'Carbs',
                  value: dayTotal.carbsG,
                  goal: dailyGoals['carbs']!,
                  percentage: percentageCarbs,
                  unit: 'g',
                  color: NutriColors.accentLight,
                ),
              ],
            ),
          ),

          // Totals Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTotalItem(
                  label: 'Calories',
                  value: dayTotal.caloriesKcal.toStringAsFixed(0),
                  color: NutriColors.accent,
                ),
                _buildTotalItem(
                  label: 'Protein',
                  value: dayTotal.proteinG.toStringAsFixed(0),
                  color: NutriColors.success,
                ),
                _buildTotalItem(
                  label: 'Fat',
                  value: dayTotal.fatG.toStringAsFixed(0),
                  color: NutriColors.danger,
                ),
                _buildTotalItem(
                  label: 'Carbs',
                  value: dayTotal.carbsG.toStringAsFixed(0),
                  color: NutriColors.accentLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientProgressBar({
    required String label,
    required double value,
    required double goal,
    required double percentage,
    required String unit,
    required Color color,
  }) {
    final percentageText = (percentage * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: NutriColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percentageText%',
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: MediaQuery.of(context).size.width * 0.8 * percentage,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${value.toStringAsFixed(0)}/$goal',
              style: TextStyle(
                fontSize: 14,
                color: NutriColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: NutriColors.textSecondary,
          ),
        ),
      ],
    );
  }
}