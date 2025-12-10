import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/Features/logs/user_log_model.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
import 'logs_api.dart';

class LogsHistoryScreen2 extends StatefulWidget {
  const LogsHistoryScreen2({super.key});

  @override
  _LogsHistoryScreenState createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen2> {
  List<UserLog> logs = [];
  bool loading = true;
  Map<String, List<UserLog>> groupedLogs = {};
  Map<String, Map<String, double>> dailyTotals = {};

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      final result = await logsApi.getHistory();

      setState(() {
        logs = result;
        _groupLogsByDate();
        loading = false;
      });
    } catch (e) {
      setState(() {
        logs = [];
        loading = false;
      });
    }
  }

  void _groupLogsByDate() {
    groupedLogs.clear();
    dailyTotals.clear();

    // Sort logs by date (newest first)
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    for (var log in logs) {
      final date = log.timestamp.toIso8601String().split('T')[0];

      // Group logs by date
      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }
      groupedLogs[date]!.add(log);

      // Calculate daily totals
      if (!dailyTotals.containsKey(date)) {
        dailyTotals[date] = {
          'calories': 0.0,
          'protein': 0.0,
          'fat': 0.0,
          'carbs': 0.0,
        };
      }

      final food = log.food;
      if (food != null) {
        final multiplier = log.quantity / 100; // Assuming quantity is in grams
        dailyTotals[date]!['calories'] = dailyTotals[date]!['calories']! + (food.caloriesKcal * multiplier);
        dailyTotals[date]!['protein'] = dailyTotals[date]!['protein']! + (food.proteinG * multiplier);
        dailyTotals[date]!['fat'] = dailyTotals[date]!['fat']! + (food.fatG * multiplier);
        dailyTotals[date]!['carbs'] = dailyTotals[date]!['carbs']! + (food.carbsG * multiplier);
      }
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
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
          "Nutrition History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getHistory,
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: NutriColors.primary),
      )
          : logs.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: NutriColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No Logs Yet',
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
              'Start logging your meals to track your nutrition history',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: NutriColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: NutriColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Start Logging'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final dates = groupedLogs.keys.toList();

    return Column(
      children: [
        // Overall Progress Summary
        _buildProgressSummary(),

        // Daily Logs List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final dateLogs = groupedLogs[date]!;
              final totals = dailyTotals[date]!;

              return _buildDateSection(date, dateLogs, totals);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSummary() {
    // Calculate overall totals
    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;

    for (var total in dailyTotals.values) {
      totalCalories += total['calories']!;
      totalProtein += total['protein']!;
      totalFat += total['fat']!;
      totalCarbs += total['carbs']!;
    }

    final daysCount = dailyTotals.length;
    final avgCalories = daysCount > 0 ? totalCalories / daysCount : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: NutriColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: NutriColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$daysCount days',
                  style: TextStyle(
                    color: NutriColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildProgressItem(
                label: 'Avg Calories',
                value: avgCalories.toStringAsFixed(0),
                unit: 'Cal',
                color: NutriColors.accent,
              ),
              const SizedBox(width: 20),
              _buildProgressItem(
                label: 'Protein',
                value: totalProtein.toStringAsFixed(0),
                unit: 'g',
                color: NutriColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildProgressItem(
                label: 'Fat',
                value: totalFat.toStringAsFixed(0),
                unit: 'g',
                color: NutriColors.danger,
              ),
              const SizedBox(width: 20),
              _buildProgressItem(
                label: 'Carbs',
                value: totalCarbs.toStringAsFixed(0),
                unit: 'g',
                color: NutriColors.accentLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: NutriColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: NutriColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date, List<UserLog> dateLogs, Map<String, double> totals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Date Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.textPrimary,
                  ),
                ),
                Text(
                  '${dateLogs.length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: NutriColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Daily Totals
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDailyTotalItem(
                  value: totals['calories']!.toStringAsFixed(0),
                  unit: 'Cal',
                  label: 'Calories',
                  color: NutriColors.accent,
                ),
                _buildDailyTotalItem(
                  value: totals['protein']!.toStringAsFixed(0),
                  unit: 'g',
                  label: 'Protein',
                  color: NutriColors.success,
                ),
                _buildDailyTotalItem(
                  value: totals['carbs']!.toStringAsFixed(0),
                  unit: 'g',
                  label: 'Carbs',
                  color: NutriColors.accentLight,
                ),
                _buildDailyTotalItem(
                  value: totals['fat']!.toStringAsFixed(0),
                  unit: 'g',
                  label: 'Fat',
                  color: NutriColors.danger,
                ),
              ],
            ),
          ),

          // Log Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dateLogs.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
            itemBuilder: (context, index) {
              final log = dateLogs[index];
              return _buildLogItem(log);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDailyTotalItem({
    required String value,
    required String unit,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: NutriColors.textSecondary,
              ),
            ),
          ],
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

  Widget _buildLogItem(UserLog log) {
    final food = log.food;
    if (food == null) return const SizedBox();

    final multiplier = log.quantity / 100;
    final calories = (food.caloriesKcal * multiplier).toStringAsFixed(0);
    final protein = (food.proteinG * multiplier).toStringAsFixed(1);
    final fat = (food.fatG * multiplier).toStringAsFixed(1);
    final carbs = (food.carbsG * multiplier).toStringAsFixed(1);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: NutriColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.restaurant,
          color: NutriColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        food.nameEn,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: NutriColors.textPrimary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${log.quantity} ${log.unit}',
            style: TextStyle(
              color: NutriColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            children: [
              _buildNutrientChip('$calories Cal', NutriColors.accent),
              _buildNutrientChip('$protein g P', NutriColors.success),
              _buildNutrientChip('$fat g F', NutriColors.danger),
              _buildNutrientChip('$carbs g C', NutriColors.accentLight),
            ],
          ),
        ],
      ),
      trailing: Text(
        log.timestamp.hour.toString().padLeft(2, '0') + ':' +
            log.timestamp.minute.toString().padLeft(2, '0'),
        style: TextStyle(
          color: NutriColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}