import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../Features/logs/user_log_model.dart';
import '../Features/profile/profile_model.dart';
import '../UI/splashes/app_colors.dart';
import '../UI/widgets/bottom_control_panel.dart';

class DailyNutritionDashboard extends StatefulWidget {
  final Future<List<UserLog>> Function() getHistory;
  final Future<UserProfile?> Function() getProfile;

  const DailyNutritionDashboard({
    Key? key,
    required this.getHistory,
    required this.getProfile,
  }) : super(key: key);

  @override
  State<DailyNutritionDashboard> createState() =>
      _DailyNutritionDashboardState();
}

class _DailyNutritionDashboardState extends State<DailyNutritionDashboard> {
  /// List of logs for today
  List<UserLog> logsHistory = [];
  /// User profile
  UserProfile? profile;
  /// Loading indicator
  bool loading = true;

  /// Goal macros (default, will be overwritten by profile if available)
  double dailyCalories = 3400;
  double dailyProtein = 150;
  double dailyFat = 138;
  double dailyCarbs = 340;

  /// Totals consumed today
  double totalCalories = 0;
  double totalProtein = 0;
  double totalFat = 0;
  double totalCarbs = 0;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  /// Converts dynamic backend numbers (int, double, String) to double safely
  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  /// Load profile and today logs from backend
  Future<void> loadDashboardData() async {
    setState(() => loading = true);
    try {
      // Fetch profile
      final fetchedProfile = await widget.getProfile();  // here
      debugPrint('PROFILE FETCHED (dashboard): $fetchedProfile');
      profile = fetchedProfile;

      if (fetchedProfile == null) {
        // Profile doesn't exist yet - create default profile in memory
        debugPrint('No profile found - using default values');
        profile = UserProfile(
          username: "User",
          dailyCalories: 2400, // Use sensible defaults
          dailyProtein: 150,
          dailyFat: 70,
          dailyCarbs: 300, email: 'user@gmail.com', gender: 'male', activityLevel: 'sedentary',
        );
      } else {
        profile = fetchedProfile;
      }


      // Override default goals with backend values safely
      dailyCalories = _toDouble(profile?.dailyCalories) ?? dailyCalories;
      dailyProtein = _toDouble(profile?.dailyProtein) ?? dailyProtein;
      dailyFat = _toDouble(profile?.dailyFat) ?? dailyFat;
      dailyCarbs = _toDouble(profile?.dailyCarbs) ?? dailyCarbs;

      debugPrint('GOALS: Calories=$dailyCalories Protein=$dailyProtein Fat=$dailyFat Carbs=$dailyCarbs');



      // 2️⃣ Fetch logs
      final allHistory  = await widget.getHistory();  // featch daily logs.
      debugPrint('Dashboard -> getHistory returned: ${allHistory.length}');
      // debug sample of timestamps
      if (allHistory.isNotEmpty) {
        debugPrint('First timestamps sample: ${allHistory.take(5).map((l)=>l.timestamp).toList()}');
      }

      // Filter today logs (make sure timestamp is DateTime)
      final now = DateTime.now();
      bool isSameLocalDay(DateTime a, DateTime b) {
        final al = a.toLocal();
        final bl = b.toLocal();
        return al.year == bl.year && al.month == bl.month && al.day == bl.day;
      }
      final todayLogsFiltered = allHistory.where((log) => isSameLocalDay(log.timestamp, now)).toList();
      debugPrint('Dashboard -> todayLogsFiltered count: ${todayLogsFiltered.length}');

      setState(() {
        logsHistory = todayLogsFiltered;
      });

      // Calculate totals
      calculateTotals();
      debugPrint('Totals calculated: $totalCalories, $totalProtein, $totalFat, $totalCarbs');

    } catch (e, st) {
      debugPrint('ERROR LOADING DASHBOARD DATA: $e\n$st');
      // If error occurs, use default values
      profile = UserProfile(
        username: "User",
        dailyCalories: 2400,
        dailyProtein: 150,
        dailyFat: 70,
        dailyCarbs: 300, email: 'user@gmail.com', gender: 'male', activityLevel: 'sedentary',
      );

      dailyCalories = 2400;
      dailyProtein = 150;
      dailyFat = 70;
      dailyCarbs = 300;


      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Using default nutrition goals')));
    } finally {
      setState(() => loading = false);
    }
  }

  /// Calculate total macros and calories from today logs
  void calculateTotals() {
    totalCalories = 0;
    totalProtein = 0;
    totalFat = 0;
    totalCarbs = 0;

    for (var log in logsHistory) {
      final food = log.food;
      if (food == null) continue;

      final multiplier = log.quantity / food.servingSize;

      totalCalories += food.caloriesKcal * multiplier;
      totalProtein += food.proteinG * multiplier;
      totalFat += food.fatG * multiplier;
      totalCarbs += food.carbsG * multiplier;
    }
  }

  @override
  Widget build(BuildContext context) {
    final calorieProgress = (totalCalories / dailyCalories).clamp(0.0, 1.0);

    if (loading) {
      return const Scaffold(
        backgroundColor: NutriColors.background,
        body: Center(
          child: CircularProgressIndicator(color: NutriColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: NutriColors.background,
      body: RefreshIndicator(
        onRefresh: loadDashboardData,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            /// Header section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: NutriColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome back,",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(profile?.username??"User", style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text("Daily Goal",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(totalCalories.round().toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                      Text(" /${dailyCalories.round()} Cal",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 80,
                    lineHeight: 12,
                    percent: calorieProgress,
                    backgroundColor: Colors.white24,
                    progressColor: NutriColors.accentLight,
                    barRadius: const Radius.circular(8),
                  ),
                  Text("${(dailyCalories - totalCalories).round()} left",
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Macros section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Today's Macros",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: NutriColors.textPrimary)),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroCircle(
                    "Protein", totalProtein.round(), dailyProtein.round(), "g",
                    Colors.blue[700]!),
                _MacroCircle(
                    "Fats", totalFat.round(), dailyFat.round(), "g",
                    Colors.amber[700]!),
                _MacroCircle(
                    "Carbs", totalCarbs.round(), dailyCarbs.round(), "g",
                    Colors.purple[600]!),
              ],
            ),

            const SizedBox(height: 32),

            /// Today's Meals section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Today's Meals",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),

            if (logsHistory.isEmpty)
              const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text("No food logged today",
                        style: TextStyle(color: NutriColors.textSecondary)),
                  ))
            else
              ...logsHistory.map((log) => _FoodLogCard(log: log)),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 0),
    );
  }
}

/// Reusable Macro Circle Widget
class _MacroCircle extends StatelessWidget {
  final String title;
  final int current;
  final int goal;
  final String unit;
  final Color color;

  const _MacroCircle(this.title, this.current, this.goal, this.unit, this.color);

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 48,
          lineWidth: 9,
          percent: progress,
          center: Text("$current\n$unit",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          footer: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(title,
                  style: const TextStyle(fontSize: 14, color: NutriColors.textSecondary))),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        Text("of $goal$unit",
            style: const TextStyle(fontSize: 12, color: NutriColors.textSecondary)),
      ],
    );
  }
}

/// Single food log card
class _FoodLogCard extends StatelessWidget {
  final UserLog log;

  const _FoodLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final food = log.food;
    if (food == null) return const SizedBox.shrink();

    final multiplier = log.quantity / food.servingSize;
    final cal = (food.caloriesKcal * multiplier).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: NutriColors.primary.withOpacity(0.1),
          child: const Icon(Icons.restaurant, color: NutriColors.primary),
        ),
        title: Text("${log.food?.nameEn} • ${log.quantity}${log.unit}"),
        subtitle: Text(
          "${log.food?.caloriesKcal} kcal × ${multiplier.toStringAsFixed(1)} = ${cal} kcal  •  "
              "${log.food?.proteinG}g P  •  ${log.food?.fatG}g F  •  ${log.food?.carbsG}g C",
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Text(DateFormat('h:mm a').format(log.timestamp),
            style: const TextStyle(color: NutriColors.textSecondary)),
      ),
    );
  }
}
